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
    @Environment(\.scenePhase) private var scenePhase
    @State private var sessionViewModel: AppSessionViewModel
    private let loginViewModel: LoginViewModel
    private let profileRepository: ProfileRepository
    private let apiClient: APIClientProtocol

    init() {
        let tokenStore = InMemoryTokenStore()
        let refreshTokenStore = KeychainRefreshTokenStore()
        let apiClient = APIClient(
            baseURL: APIEnvironment.devBaseURL,
            tokenProvider: tokenStore,
            tokenStore: tokenStore,
            refreshTokenStore: refreshTokenStore
        )
        let authRepository = RemoteAuthRepository(apiClient: apiClient)
        let profileRepository = RemoteProfileRepository(apiClient: apiClient)

        guard let kakaoNativeAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String else {
            fatalError("Info.plist에 KAKAO_NATIVE_APP_KEY가 없습니다")
        }
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)

        self.apiClient = apiClient
        self.profileRepository = profileRepository

        let sessionViewModel = AppSessionViewModel(
            authRepository: authRepository,
            profileRepository: profileRepository,
            tokenStore: tokenStore,
            refreshTokenStore: refreshTokenStore,
            apiClient: apiClient
        )
        _sessionViewModel = State(initialValue: sessionViewModel)
        apiClient.setSessionExpiredHandler { sessionViewModel.handleSessionExpired() }

        let loginViewModel = LoginViewModel(
            authRepository: authRepository,
            tokenStore: tokenStore,
            refreshTokenStore: refreshTokenStore
        )
        loginViewModel.onLoginSuccess = { Task { await sessionViewModel.handleLoginSuccess() } }
        loginViewModel.onGuestContinue = { sessionViewModel.continueAsGuest() }
        self.loginViewModel = loginViewModel
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if sessionViewModel.isRestoringSession {
                    SplashView()
                } else {
                    switch sessionViewModel.sessionState {
                    case .needsProfileSetup:
                        ProfileSetupView(
                            profileViewModel: ProfileSetupViewModel(profileRepository: profileRepository),
                            onCompleted: { sessionViewModel.handleProfileRegistered() }
                        )
                    case .loggedIn, .guest:
                        PickpleBottomNav(
                            myPageViewModel: MyPageViewModel(
                                userInfoRepository: RemoteUserInfoRepository(apiClient: apiClient),
                                userPostRepository: RemoteUserPostRepository(apiClient: apiClient),
                                isLoggedIn: sessionViewModel.sessionState == .loggedIn
                            )
                        )
                            .environment(\.appLogout, sessionViewModel.logout)
                            .environment(\.appDeleteAccount, sessionViewModel.deleteAccount)
                            .environment(\.apiClient, apiClient)
                            .environment(\.isLoggedIn, sessionViewModel.sessionState == .loggedIn)
                            .environment(\.appRequestLogin, sessionViewModel.requestLogin)
                    case .loggedOut:
                        NavigationStack {
                            LoginView(loginViewModel: loginViewModel)
                        }
                    }
                }
            }.onOpenURL(perform: { url in
                    _ = AuthController.handleOpenUrl(url: url)
            })
            .dismissKeyboardOnTap()
            .task {
                await sessionViewModel.restoreSession()
            }
            .onChange(of: scenePhase) { _, newPhase in
                // 백그라운드에 오래 있으면 프로세스가 통째로 멈춰서 예약해둔 갱신 타이머가
                // 못 돌았을 수 있다 — 포그라운드로 돌아올 때마다 다시 보정한다.
                guard newPhase == .active else { return }
                sessionViewModel.handleAppBecameActive()
            }
        }
    }
}
