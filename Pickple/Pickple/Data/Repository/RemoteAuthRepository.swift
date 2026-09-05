//
//  RemoteAuthRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import Foundation

struct AppleLoginRequestDTO: Encodable {
    let authorizationCode: String
    let identityToken: String
    let rawNonce: String
    let name: String?
}

struct KakaoLoginRequestDTO: Encodable {
    let identityToken: String?
    let rawNonce: String
}

struct MobileRefreshRequestDTO: Encodable {
    let refreshToken: String
}

struct AuthTokensDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}

struct RemoteAuthRepository: AuthRepository {
    let apiClient: APIClientProtocol

    func loginWithApple(authorizationCode: String, identityToken: String, rawNonce: String, name: String?) async throws -> AuthTokens {
        let body = try JSONEncoder().encode(AppleLoginRequestDTO(
            authorizationCode: authorizationCode,
            identityToken: identityToken,
            rawNonce: rawNonce,
            name: name
        ))
        let endpoint = APIEndpoint(method: .post, path: "/auth/apple", body: body, requiresAuth: false)
        let dto: AuthTokensDTO = try await apiClient.request(endpoint)
        return AuthTokens(accessToken: dto.accessToken, refreshToken: dto.refreshToken)
    }
    
    func loginWithKakao(identityToken: String?, rawNonce: String) async throws -> AuthTokens {
            let body = try JSONEncoder().encode(KakaoLoginRequestDTO(
                identityToken: identityToken,
                rawNonce: rawNonce,
            ))
            let endpoint = APIEndpoint(method: .post, path: "/auth/kako", body: body, requiresAuth: false)
            let dto: AuthTokensDTO = try await apiClient.request(endpoint)
            return AuthTokens(accessToken: dto.accessToken, refreshToken: dto.refreshToken)
    }

    func refreshAccessToken(refreshToken: String) async throws -> AuthTokens {
        let body = try JSONEncoder().encode(MobileRefreshRequestDTO(refreshToken: refreshToken))
        let endpoint = APIEndpoint(method: .post, path: "/auth/mobile/refresh", body: body, requiresAuth: false)
        let dto: AuthTokensDTO = try await apiClient.request(endpoint)
        return AuthTokens(accessToken: dto.accessToken, refreshToken: dto.refreshToken)
    }

    func logout() async throws {
        let endpoint = APIEndpoint(method: .post, path: "/auth/logout", requiresAuth: true)
        try await apiClient.requestVoid(endpoint)
    }

    func deleteAccount() async throws {
        // "Apple 연결 해제(revoke)는 Bearer 없이 처리"라는 답은 서버가 내부적으로 Apple에
        // 보내는 요청(서버가 별도로 갖고 있는 Apple provider 토큰 사용) 얘기였다.
        // /auth/me 요청 자체는 "나"를 식별해야 하므로 Bearer가 필요하다 — 401로 실제 확인됨.
        let endpoint = APIEndpoint(method: .delete, path: "/auth/me", requiresAuth: true)
        try await apiClient.requestVoid(endpoint)
    }
}
