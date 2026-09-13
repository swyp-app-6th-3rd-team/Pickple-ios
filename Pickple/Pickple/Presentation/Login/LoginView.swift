//
//  LoginView.swift
//  Pickple
//
//  Created by 박윤수 on 8/24/26.
//
//MARK: - 완료
// 1차 점검 완료 - 9월 13일
// 하단 설명 지우고 간격 이게 맞나?

import SwiftUI

struct LoginView: View {
    let loginViewModel: LoginViewModel

    var body: some View {
        VStack {
            Spacer()

            //MARK: - Title
            VStack(spacing: 4) {
                Image("PickpleLoginLogo")
                    .resizable()
                    .frame(width: 200, height: 45)

                //XMARK: - OnBoardingImage
                VStack(spacing: 7) {
                    Image("PickpleOnBoardingImage")
                        .resizable()
                        .frame(width: 350, height: 350)

                    //MARK: - Login Buttons
                    VStack(spacing: 8) {
                        LoginButtonSection(loginViewModel: loginViewModel)
                    }
                    .padding(.horizontal, 20)
                }
            }
            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
        .alert(LoginStrings.loginFailedTitle, isPresented: Binding(
            get: { loginViewModel.errorMessage != nil },
            set: { isPresented in if !isPresented { loginViewModel.errorMessage = nil } }
        )) {
            Button(LoginStrings.confirm, role: .cancel) {}
        } message: {
            Text(loginViewModel.errorMessage ?? "")
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
    LoginView(loginViewModel: loginViewModel)
}
