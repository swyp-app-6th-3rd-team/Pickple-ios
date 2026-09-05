//
//  AuthRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

protocol AuthRepository {
    func loginWithApple(authorizationCode: String, identityToken: String, rawNonce: String, name: String?) async throws -> AuthTokens
    func loginWithKakao(identityToken: String?, rawNonce: String) async throws -> AuthTokens
    func refreshAccessToken(refreshToken: String) async throws -> AuthTokens
    func logout() async throws
    func deleteAccount() async throws
}
