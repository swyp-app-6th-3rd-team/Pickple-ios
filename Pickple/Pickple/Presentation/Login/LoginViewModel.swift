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
    var onLoginSuccess: () -> Void = {}
    var onGuestContinue: () -> Void = {}

    init(authRepository: AuthRepository, tokenStore: InMemoryTokenStore, refreshTokenStore: RefreshTokenStoring) {
        self.authRepository = authRepository
        self.tokenStore = tokenStore
        self.refreshTokenStore = refreshTokenStore
    }

    @MainActor
    func loginWithApple() async {
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
            onLoginSuccess()
        } catch let error as ASAuthorizationError where error.code == .canceled {
            // 사용자가 Apple 로그인 시트를 직접 취소한 경우 — 에러가 아니라 정상적인 중단이라 alert을 띄우지 않는다.
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func loginWithKakao() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let result = try await kakaoCoordinator.login()
            let tokens = try await authRepository.loginWithKakao(
                identityToken: result.identityToken,
                rawNonce: result.rawNonce
            )
            try await SessionTokenPersistence.save(tokens, tokenStore: tokenStore, refreshTokenStore: refreshTokenStore)
            onLoginSuccess()
        } catch SdkError.ClientFailed(reason: .Cancelled, errorMessage: _) {
            // 사용자가 카카오 로그인 화면을 직접 취소한 경우 — 에러가 아니라 정상적인 중단이라 alert을 띄우지 않는다.
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func continueAsGuest() {
        onGuestContinue()
    }
}
