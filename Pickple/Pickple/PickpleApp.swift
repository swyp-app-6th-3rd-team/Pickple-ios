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
    private let profileRepository: ProfileRepository

    init() {
        let tokenStore = InMemoryTokenStore()
        let apiClient = APIClient(baseURL: APIEnvironment.devBaseURL, tokenProvider: tokenStore)
        let authRepository = RemoteAuthRepository(apiClient: apiClient)
        let profileRepository = RemoteProfileRepository(apiClient: apiClient)
        let refreshTokenStore = KeychainRefreshTokenStore()

        self.profileRepository = profileRepository
        _sessionViewModel = State(initialValue: AppSessionViewModel(
            authRepository: authRepository,
            profileRepository: profileRepository,
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
                } else if sessionViewModel.needsProfileSetup {
                    ProfileView(
                        profileViewModel: ProfileViewModel(profileRepository: profileRepository),
                        onCompleted: { sessionViewModel.handleProfileRegistered() }
                    )
                } else if sessionViewModel.isLoggedIn {
                    PickpleBottomNav()
                        .environment(\.appLogout, sessionViewModel.logout)
                        .environment(\.appDeleteAccount, sessionViewModel.deleteAccount)
                } else {
                    NavigationStack {
                        LoginView(viewModel: loginViewModel, onLoginSuccess: {
                            Task { await sessionViewModel.handleLoginSuccess() }
                        })
                    }
                }
            }
            .task {
                await sessionViewModel.restoreSession()
            }
        }
    }
}
