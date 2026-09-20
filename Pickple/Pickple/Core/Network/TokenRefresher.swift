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
    // 재발급이 완전히 실패했을 때(리프레시 토큰까지 무효) 상위(AppSessionViewModel)에 알려서
    // 로그인 화면으로 돌려보내는 데 쓴다. APIClient 생성 시점엔 세션 뷰모델이 아직 없어서
    // init에서 안 받고, 만들어진 뒤에 나중에 채워 넣는다(PickpleApp 참고).
    var onRefreshFailed: (@MainActor () -> Void)?

    // nonisolated: APIClient.init(nonisolated 컨텍스트)에서 동기적으로 생성해야 한다 —
    // 여기선 값 저장만 하고 MainActor가 필요한 작업(재발급 로직)은 없어서 안전하다.
    nonisolated init(
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
            print("[TokenRefresh] 이미 진행 중인 갱신에 합류 (\(Date()))")
            return try await inFlightTask.value
        }

        let task = Task<String, Error> {
            guard let refreshToken = refreshTokenStore.load() else {
                print("[TokenRefresh] refreshToken을 Keychain에서 못 읽음 (\(Date()))")
                throw APIError.unauthorized
            }
            print("[TokenRefresh] /auth/mobile/refresh 요청 시작 (\(Date()))")
            let tokens = try await performRefresh(refreshToken)
            await tokenStore.update(tokens.accessToken)
            try refreshTokenStore.save(tokens.refreshToken)
            print("[TokenRefresh] /auth/mobile/refresh 완료 — 새 토큰=\(tokens.accessToken.suffix(12)) (\(Date()))")
            return tokens.accessToken
        }
        inFlightTask = task
        defer { inFlightTask = nil }

        do {
            return try await task.value
        } catch {
            // 재발급 자체가 실패했다(refreshToken도 만료/무효) — 다음 로그인까지는 재시도해도
            // 어차피 또 실패하니, 저장된 refreshToken을 지워서 재로그인이 필요한 상태로 정리한다.
            print("[TokenRefresh] 갱신 실패 — refreshToken 정리, 세션 만료 처리: \(error) (\(Date()))")
            refreshTokenStore.clear()
            onRefreshFailed?()
            throw error
        }
    }
}
