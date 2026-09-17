//
//  TokenRefresher.swift
//  Pickple
//
//  Created by 박윤수 on 9/17/26.
//
//  APIClient가 401을 받았을 때 accessToken을 재발급받기 위해 쓰는 보조 객체.
//  여러 요청이 동시에 401을 맞아도 재발급 호출은 한 번만 나가도록(single-flight) 여기서 묶는다 —
//  각자 재발급을 시도하면 refreshToken이 먼저 쓰인 쪽만 성공하고 나머지는 실패할 수 있어서다.
//
//  actor가 아니라 @MainActor 클래스인 이유: 이 프로젝트는 -default-isolation=MainActor라
//  MobileRefreshRequestDTO/AuthTokensDTO 같은 DTO의 Encodable/Decodable 준수가 기본적으로
//  MainActor 격리다. 별도 actor로 만들면 그 DTO들을 이 타입 안에서 인코딩/디코딩할 때마다
//  "격리가 다른 conformance를 쓸 수 없다"는 Swift 6 에러가 난다 — MainActor에 맞추면 나머지
//  코드베이스와 격리 도메인이 같아져서 이 문제 자체가 없어진다. single-flight 보장은 액터와
//  마찬가지로 MainActor도 한 번에 하나씩만 실행되므로 그대로 유지된다.

import Foundation

@MainActor
final class TokenRefresher {
    private let refreshTokenStore: RefreshTokenStoring
    private let tokenStore: InMemoryTokenStore
    private let performRefresh: @MainActor @Sendable (String) async throws -> AuthTokens
    private var inFlightTask: Task<String, Error>?

    init(
        refreshTokenStore: RefreshTokenStoring,
        tokenStore: InMemoryTokenStore,
        performRefresh: @escaping @MainActor @Sendable (String) async throws -> AuthTokens
    ) {
        self.refreshTokenStore = refreshTokenStore
        self.tokenStore = tokenStore
        self.performRefresh = performRefresh
    }

    // 새 accessToken을 반환한다. 이미 재발급이 진행 중이면 그 결과를 같이 기다린다.
    func refreshedAccessToken() async throws -> String {
        if let inFlightTask {
            return try await inFlightTask.value
        }

        let task = Task<String, Error> {
            guard let refreshToken = refreshTokenStore.load() else { throw APIError.unauthorized }
            let tokens = try await performRefresh(refreshToken)
            await tokenStore.update(tokens.accessToken)
            try refreshTokenStore.save(tokens.refreshToken)
            return tokens.accessToken
        }
        inFlightTask = task
        defer { inFlightTask = nil }

        do {
            return try await task.value
        } catch {
            // 재발급 자체가 실패했다(refreshToken도 만료/무효) — 다음 로그인까지는 재시도해도
            // 어차피 또 실패하니, 저장된 refreshToken을 지워서 재로그인이 필요한 상태로 정리한다.
            refreshTokenStore.clear()
            throw error
        }
    }
}
