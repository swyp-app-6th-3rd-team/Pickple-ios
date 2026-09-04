//
//  PickpleApp.swift
//  Pickple
//
//  Created by 박윤수 on 8/24/26.
//

import SwiftUI

@main
struct PickpleApp: App {
    @State private var sessionViewModel: AppSessionViewModel
    private let loginViewModel: LoginViewModel

    init() {
        let tokenStore = InMemoryTokenStore()
        let apiClient = APIClient(baseURL: APIEnvironment.devBaseURL, tokenProvider: tokenStore)
        let authRepository = RemoteAuthRepository(apiClient: apiClient)
        let refreshTokenStore = KeychainRefreshTokenStore()

        _sessionViewModel = State(initialValue: AppSessionViewModel(
            authRepository: authRepository,
            tokenStore: tokenStore,
            refreshTokenStore: refreshTokenStore
        ))
        loginViewModel = LoginViewModel(
            authRepository: authRepository,
            tokenStore: tokenStore,
            refreshTokenStore: refreshTokenStore
        )
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if sessionViewModel.isRestoringSession {
                    Color.clear
                } else if sessionViewModel.isLoggedIn {
                    PickpleBottomNav()
                        .environment(\.appLogout, sessionViewModel.logout)
                        .environment(\.appDeleteAccount, sessionViewModel.deleteAccount)
                } else {
                    NavigationStack {
                        LoginView(viewModel: loginViewModel, onLoginSuccess: { sessionViewModel.markLoggedIn() })
                    }
                }
            }
            .task {
                await sessionViewModel.restoreSession()
            }
        }
    }
}
