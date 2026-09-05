//
//  LoginViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//
import Foundation
import AuthenticationServices
import KakaoSDKCommon

@Observable
class LoginViewModel {
    private let appleCoordinator = AppleLoginCoordinator()
    private let kakaoCoordinator = KakaoLoginCoordinator()
    private let authRepository: AuthRepository
    private let tokenStore: InMemoryTokenStore
    private let refreshTokenStore: RefreshTokenStoring

    var isLoading = false
    var errorMessage: String?

    init(authRepository: AuthRepository, tokenStore: InMemoryTokenStore, refreshTokenStore: RefreshTokenStoring) {
        self.authRepository = authRepository
        self.tokenStore = tokenStore
        self.refreshTokenStore = refreshTokenStore
    }

    // 반환값이 성공 여부를 나타내는 유일한 근거다 — errorMessage가 nil인 것만으로는
    // "성공"과 "사용자가 취소해서 에러를 안 띄운 경우"를 구분할 수 없어서 별도로 필요하다.
    @MainActor
    @discardableResult
    func loginWithApple() async -> Bool {
        isLoading = true
        defer { isLoading = false }
        do {
            let result = try await appleCoordinator.login()
            let tokens = try await authRepository.loginWithApple(
                authorizationCode: result.authorizationCode,
                identityToken: result.identityToken,
                rawNonce: result.rawNonce,
                name: result.fullName.map { PersonNameComponentsFormatter().string(from: $0) }
            )
            try await SessionTokenPersistence.save(tokens, tokenStore: tokenStore, refreshTokenStore: refreshTokenStore)
            return true
        } catch let error as ASAuthorizationError where error.code == .canceled {
            // 사용자가 Apple 로그인 시트를 직접 취소한 경우 — 에러가 아니라 정상적인 중단이라 alert을 띄우지 않는다.
            return false
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    @MainActor
    func loginWithKakao() async -> Bool {
        isLoading = true
        defer { isLoading = false }
        do {
            let result = try await kakaoCoordinator.login()
            let tokens = try await authRepository.loginWithKakao(
                identityToken: result.identityToken,
                rawNonce: result.rawNonce
            )
            try await SessionTokenPersistence.save(tokens, tokenStore: tokenStore, refreshTokenStore: refreshTokenStore)
            return true
        } catch SdkError.ClientFailed(reason: .Cancelled, errorMessage: _) {
            // 사용자가 카카오 로그인 화면을 직접 취소한 경우 — 에러가 아니라 정상적인 중단이라 alert을 띄우지 않는다.
            return false
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
