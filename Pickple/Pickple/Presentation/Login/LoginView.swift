//
//  LoginView.swift
//  Pickple
//
//  Created by 박윤수 on 8/24/26.
//

import SwiftUI

struct LoginView: View {
    let viewModel: LoginViewModel
    var onLoginSuccess: () -> Void = {}

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            //MARK: - Title
            VStack(spacing: 7) {
                Image("PickpleLoginLogo")
                    .resizable()
                    .frame(width: 200, height: 45)

                //XMARK: - OnBoardingImage
                VStack(spacing: 0) {
                    Image("PickpleOnBoardingImage")
                        .resizable()
                        .frame(width: 350, height: 350)

                    //MARK: - Login Buttons
                    VStack(spacing: 8) {
                        LoginButton(provider: .kakao) {
                            Task {
                                if await viewModel.loginWithKakao() {
                                    onLoginSuccess()
                                }
                            }
                        }
                        LoginButton(provider: .apple) {
                            Task {
                                if await viewModel.loginWithApple() {
                                    onLoginSuccess()
                                }
                            }
                        }
                        LoginButton(provider: .guest) {
                            onLoginSuccess()
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            //XMARK: - Text
            Text(LoginStrings.termsNotice)
                .pickpleTypography(.caption)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.neutral30)

        }
        .alert(LoginStrings.loginFailedTitle, isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { isPresented in if !isPresented { viewModel.errorMessage = nil } }
        )) {
            Button(LoginStrings.confirm, role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}


#Preview {
    let tokenStore = InMemoryTokenStore()
    let apiClient = APIClient(baseURL: APIEnvironment.devBaseURL, tokenProvider: tokenStore)
    let viewModel = LoginViewModel(
        authRepository: RemoteAuthRepository(apiClient: apiClient),
        tokenStore: tokenStore,
        refreshTokenStore: KeychainRefreshTokenStore()
    )
    LoginView(viewModel: viewModel)
}
