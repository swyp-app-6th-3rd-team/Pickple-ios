//
//  LoginButtonSection.swift
//  Pickple
//
//  Created by 박윤수 on 9/9/26.
//
// 1차 점검 완료 - 9월 13일

import SwiftUI

struct LoginButtonSection: View {
    let loginViewModel: LoginViewModel

    var body: some View {
        LoginButton(provider: .kakao) {
            Task { await loginViewModel.loginWithKakao() }
        }
        LoginButton(provider: .apple) {
            Task { await loginViewModel.loginWithApple() }
        }
        LoginButton(provider: .guest) {
            loginViewModel.continueAsGuest()
        }
    }
}

#Preview {
    let tokenStore = InMemoryTokenStore()
    let apiClient = APIClient(baseURL: APIEnvironment.devBaseURL, tokenProvider: tokenStore)
    let loginViewModel = LoginViewModel(
        authRepository: RemoteAuthRepository(apiClient: apiClient),
        tokenStore: tokenStore,
        refreshTokenStore: KeychainRefreshTokenStore()
    )
    LoginButtonSection(loginViewModel: loginViewModel)
}
