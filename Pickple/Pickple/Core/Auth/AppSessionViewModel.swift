//
//  AppSessionViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import Foundation

// 앱 전체의 로그인 세션 상태(로그인 여부, 세션 복원 진행 중 여부)와
// 그 상태를 바꾸는 동작(자동 로그인 복원/로그아웃/탈퇴)을 소유한다.
// PickpleApp은 이 뷰모델을 만들어서 화면 분기와 Environment 주입만 담당한다.
@Observable
class AppSessionViewModel {
    private(set) var isLoggedIn = false
    private(set) var isRestoringSession = true

    private let authRepository: AuthRepository
    private let tokenStore: InMemoryTokenStore
    private let refreshTokenStore: RefreshTokenStoring

    init(authRepository: AuthRepository, tokenStore: InMemoryTokenStore, refreshTokenStore: RefreshTokenStoring) {
        self.authRepository = authRepository
        self.tokenStore = tokenStore
        self.refreshTokenStore = refreshTokenStore
    }

    func markLoggedIn() {
        isLoggedIn = true
    }

    // 앱 시작 시 Keychain에 남아있는 refreshToken으로 accessToken을 재발급받아 자동 로그인한다.
    @MainActor
    func restoreSession() async {
        defer { isRestoringSession = false }
        guard let refreshToken = refreshTokenStore.load() else { return }
        do {
            let tokens = try await authRepository.refreshAccessToken(refreshToken: refreshToken)
            await tokenStore.update(tokens.accessToken)
            try refreshTokenStore.save(tokens.refreshToken)
            isLoggedIn = true
        } catch {
            refreshTokenStore.clear()
        }
    }

    @MainActor
    func logout() async {
        // accessToken을 지우기 전에 먼저 호출해야 Bearer 헤더가 실린다.
        // 서버 호출이 실패해도(네트워크 등) 로컬 로그아웃은 그대로 진행한다.
        try? await authRepository.logout()
        refreshTokenStore.clear()
        await tokenStore.update(nil)
        isLoggedIn = false
    }

    // 실패하면(예: Apple 일시 장애 503) 로컬 상태는 그대로 두고 에러를 던진다 — 계정이 안 지워졌으니 재시도 가능해야 한다.
    @MainActor
    func deleteAccount() async throws {
        try await authRepository.deleteAccount()
        refreshTokenStore.clear()
        await tokenStore.update(nil)
        isLoggedIn = false
    }
}
