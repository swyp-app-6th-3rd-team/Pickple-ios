//
//  PickpleApp.swift
//  Pickple
//
//  Created by 박윤수 on 8/24/26.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKCommon

@main
struct PickpleApp: App {
    @State private var sessionViewModel: AppSessionViewModel
    private let loginViewModel: LoginViewModel
    private let profileRepository: ProfileRepository
    private let apiClient: APIClientProtocol

    init() {
        let tokenStore = InMemoryTokenStore()
        let apiClient = APIClient(baseURL: APIEnvironment.devBaseURL, tokenProvider: tokenStore)
        let authRepository = RemoteAuthRepository(apiClient: apiClient)
        let profileRepository = RemoteProfileRepository(apiClient: apiClient)
        let refreshTokenStore = KeychainRefreshTokenStore()
        
        guard let kakaoNativeAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String else {
            fatalError("Info.plist에 KAKAO_NATIVE_APP_KEY가 없습니다")
        }
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)

        self.apiClient = apiClient
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
                    ProfileSetupView(
                        profileViewModel: ProfileSetupViewModel(profileRepository: profileRepository),
                        onCompleted: { sessionViewModel.handleProfileRegistered() }
                    )
                } else if sessionViewModel.isLoggedIn {
                    PickpleBottomNav(
                        myPageViewModel: MyPageViewModel(
                            userInfoRepository: RemoteUserInfoRepository(apiClient: apiClient),
                            userPostRepository: RemoteUserPostRepository(apiClient: apiClient)
                        )
                    )
                        .environment(\.appLogout, sessionViewModel.logout)
                        .environment(\.appDeleteAccount, sessionViewModel.deleteAccount)
                        .environment(\.apiClient, apiClient)
                } else {
                    NavigationStack {
                        LoginView(viewModel: loginViewModel, onLoginSuccess: {
                            Task { await sessionViewModel.handleLoginSuccess() }
                        })
                    }
                }
            }.onOpenURL(perform: { url in
                    _ = AuthController.handleOpenUrl(url: url)
            })
            .task {
                await sessionViewModel.restoreSession()
            }
        }
    }
}
