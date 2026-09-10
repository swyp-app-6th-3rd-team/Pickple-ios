//
//  AppSessionViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import Foundation

// 앱 전체의 세션 상태. 게스트(둘러보기)와 완전 로그인은 둘 다 PickpleBottomNav를 보여주지만
// 실제 인증 여부가 다르므로 Bool 하나로 합치지 않고 별도 케이스로 분리한다.
enum SessionState: Equatable {
    case loggedOut
    case guest
    // 로그인은 됐지만 닉네임 등록 전(GET /users/me의 nickname == nil)이라 프로필 설정 화면을 보여줘야 하는 상태.
    case needsProfileSetup
    case loggedIn
}

// 앱 전체의 로그인 세션 상태(SessionState, 세션 복원 진행 중 여부)와
// 그 상태를 바꾸는 동작(자동 로그인 복원/게스트 진입/로그아웃/탈퇴)을 소유한다.
// PickpleApp은 이 뷰모델을 만들어서 화면 분기와 Environment 주입만 담당한다.
@Observable
class AppSessionViewModel {
    private(set) var sessionState: SessionState = .loggedOut
    private(set) var isRestoringSession = true

    private let authRepository: AuthRepository
    private let profileRepository: ProfileRepository
    private let tokenStore: InMemoryTokenStore
    private let refreshTokenStore: RefreshTokenStoring

    init(
        authRepository: AuthRepository,
        profileRepository: ProfileRepository,
        tokenStore: InMemoryTokenStore,
        refreshTokenStore: RefreshTokenStoring
    ) {
        self.authRepository = authRepository
        self.profileRepository = profileRepository
        self.tokenStore = tokenStore
        self.refreshTokenStore = refreshTokenStore
    }

    // 로그인 없이 앱을 둘러보는 상태로 전환한다. PickpleBottomNav는 그대로 보여주되,
    // 실제로는 인증되지 않았다는 걸 하위 화면들이 Environment(\.isLoggedIn)로 구분한다.
    func continueAsGuest() {
        sessionState = .guest
    }

    // 로그인 유도 모달 등에서 "로그인" 확정 시 호출 — 게스트/미로그인 상태를 벗어나 로그인 화면으로 되돌린다.
    func requestLogin() {
        sessionState = .loggedOut
    }

    // Apple/Kakao 로그인 성공 직후 호출 — 닉네임 등록 여부에 따라 프로필 설정 화면으로 보낼지 정한다.
    @MainActor
    func handleLoginSuccess() async {
        await resolveProfileState()
    }

    // 프로필 설정 화면에서 등록 완료했을 때 호출 — 신규 가입자는 그 화면 안에서 약관 동의 모달을 거친 뒤 호출된다.
    func handleProfileRegistered() {
        sessionState = .loggedIn
    }

    @MainActor
    private func resolveProfileState() async {
        do {
            let profile = try await profileRepository.fetchMyProfile()
            sessionState = (profile.nickname == nil) ? .needsProfileSetup : .loggedIn
        } catch {
            // 프로필 조회 실패해도 로그인 자체는 성공했으니, 사용자를 막지 않고 일단 메인으로 보낸다.
            sessionState = .loggedIn
        }
    }

    // 앱 시작 시 Keychain에 남아있는 refreshToken으로 accessToken을 재발급받아 자동 로그인한다.
    // 토큰이 없으면 이 작업이 거의 즉시 끝나서 스플래시가 한 프레임만 스치듯 지나가 버리므로,
    // 최소 노출 시간(SplashView 참고, 임시값)을 실제 복원 작업과 동시에 기다렸다가 더 늦게
    // 끝나는 쪽에 맞춰 스플래시를 내린다.
    @MainActor
    func restoreSession() async {
        async let minimumSplashDuration = try? await Task.sleep(for: .seconds(1.2))
        await performTokenRestore()
        _ = await minimumSplashDuration
        isRestoringSession = false
    }

    @MainActor
    private func performTokenRestore() async {
        guard let refreshToken = refreshTokenStore.load() else { return }
        do {
            let tokens = try await authRepository.refreshAccessToken(refreshToken: refreshToken)
            try await SessionTokenPersistence.save(tokens, tokenStore: tokenStore, refreshTokenStore: refreshTokenStore)
            await resolveProfileState()
        } catch {
            refreshTokenStore.clear()
        }
    }

    @MainActor
    func logout() async {
        // accessToken을 지우기 전에 먼저 호출해야 Bearer 헤더가 실린다.
        // 서버 호출이 실패해도(네트워크 등) 로컬 로그아웃은 그대로 진행한다.
        try? await authRepository.logout()
        await clearLocalSession()
    }

    // 실패하면(예: Apple 일시 장애 503) 로컬 상태는 그대로 두고 에러를 던진다 — 계정이 안 지워졌으니 재시도 가능해야 한다.
    @MainActor
    func deleteAccount() async throws {
        try await authRepository.deleteAccount()
        await clearLocalSession()
    }

    @MainActor
    private func clearLocalSession() async {
        await SessionTokenPersistence.clear(tokenStore: tokenStore, refreshTokenStore: refreshTokenStore)
        sessionState = .loggedOut
    }
}
