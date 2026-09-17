//
//  PickpleBottomNav.swift
//  Pickple
//
//  Created by 박윤수 on 8/28/26.
//
// 1차 점검 완료 - 9월 12일

import SwiftUI

struct PickpleBottomNav: View {
    @Environment(\.apiClient) private var apiClient
    @Environment(\.isLoggedIn) private var isLoggedIn
    @State private var selectedTab = 0
    @State private var mainRouter = MainRouter()
    @State private var communityRouter = CommunityRouter()
    @State private var myPageRouter = MyPageRouter()
    @State private var myPageViewModel: MyPageViewModel
    @State private var showsPostCreatedToast = false

    init(myPageViewModel: MyPageViewModel = MyPageViewModel()) {
        _myPageViewModel = State(initialValue: myPageViewModel)
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $mainRouter.path) {
                MainView(
                    mainViewModel: MainViewModel(
                        badgeMissionRepository: RemoteBadgeMissionRepository(apiClient: apiClient),
                        communityRepository: RemoteCommunityRepository(apiClient: apiClient),
                        pickerRankingRepository: RemotePickerRankingRepository(apiClient: apiClient),
                        isLoggedIn: isLoggedIn
                    ),
                    cardStackViewModel: CardStackViewModel(voteCardRepository: RemoteVoteCardRepository(apiClient: apiClient), userInfoRepository: RemoteUserInfoRepository(apiClient: apiClient), isLoggedIn: isLoggedIn),
                    onRequestCommunityTab: { selectedTab = 1 }
                )
                    .navigationDestination(for: MainRoute.self) { route in
                        switch route {
                        case .postDetail(let postId, let type):
                            PostDetailView(
                                voteType: type,
                                postDetailRepository: RemotePostDetailRepository(apiClient: apiClient, postId: postId),
                                commentRepository: RemoteCommentRepository(apiClient: apiClient, postId: postId),
                                userInfoRepository: RemoteUserInfoRepository(apiClient: apiClient),
                                voteCardRepository: RemoteVoteCardRepository(apiClient: apiClient)
                            )
                        case .ranking:
                            MainRankingView(mainRankingViewModel: MainRankingViewModel(pickerRankingRepository: RemotePickerRankingRepository(apiClient: apiClient), isLoggedIn: isLoggedIn))
                        }
                    }
            }
            .environment(mainRouter)
            // 탭바 visibility를 상세화면 각자가 개별 선언하는 대신, push/pop 애니메이션과
            // 같은 state(path)로 직접 계산한다 — 그래야 탭바 재노출이 pop과 같은 순간에
            // 반응해서, 자식 화면의 toolbar 선언이 반영되길 기다리며 생기던 지연이 없어진다.
            .toolbar(mainRouter.path.isEmpty ? .visible : .hidden, for: .tabBar)
            .tabItem { tabLabel(title: MainStrings.tabHome, icon: "PickpleHome", tag: 0) }
            .tag(0)

            NavigationStack(path: $communityRouter.path) {
                CommunityView(
                    communityViewModel: CommunityViewModel(communityRepository: RemoteCommunityRepository(apiClient: apiClient)),
                    onPostCreated: { showsPostCreatedToast = true }
                )
                    .navigationDestination(for: CommunityRoute.self) { route in
                        switch route {
                        case .postDetail(let postId, let type):
                            PostDetailView(
                                voteType: type,
                                postDetailRepository: RemotePostDetailRepository(apiClient: apiClient, postId: postId),
                                commentRepository: RemoteCommentRepository(apiClient: apiClient, postId: postId),
                                userInfoRepository: RemoteUserInfoRepository(apiClient: apiClient),
                                voteCardRepository: RemoteVoteCardRepository(apiClient: apiClient)
                            )
                        case .search:
                            CommunitySearchView(communitySearchViewModel: CommunitySearchViewModel(communityRepository: RemoteCommunityRepository(apiClient: apiClient)))
                        }
                    }
            }
            .environment(communityRouter)
            // 새 글 작성 성공 시 곧바로 상세 화면으로 push되는데, 토스트를 CommunityView
            // 자신에게 달면 push된 화면에 가려 안 보인다 — push와 무관하게 계속 보이도록
            // NavigationStack 바깥(탭 전체를 감싸는 이 레벨)에서 띄운다.
            .pickpleToast(isPresented: $showsPostCreatedToast, message: PostViewStrings.submitSucceededToast)
            .toolbar(communityRouter.path.isEmpty ? .visible : .hidden, for: .tabBar)
            .tabItem { tabLabel(title: MainStrings.tabCommunity, icon: "PickpleMessage", tag: 1) }
            .tag(1)

            NavigationStack(path: $myPageRouter.path) {
                MyPageView(myPageViewModel: myPageViewModel)
                    .navigationDestination(for: MyPageRoute.self) { route in
                        switch route {
                        case .profile:
                            MyPageProfileEditView(profileViewModel: ProfileSetupViewModel(profileRepository: RemoteProfileRepository(apiClient: apiClient)))
                        case .grade:
                            MyGradeView(myPageViewModel: myPageViewModel, gradeViewModel: MyGradeViewModel(gradeRepository: RemoteGradeRepository(apiClient: apiClient)))
                        case .badge:
                            MyBadgeView(myBadgeViewModel: MyBadgeViewModel(myBadgeRepository: RemoteMyBadgeRepository(apiClient: apiClient)))
                        case .account:
                            MyAccountView()
                        case .activity(let initialTab):
                            MyActivityView(myActivityViewModel: MyActivityViewModel(userPostRepository: RemoteUserPostRepository(apiClient: apiClient)), initialTab: initialTab)
                        case .postDetail(let postId, let type):
                            PostDetailView(
                                voteType: type,
                                postDetailRepository: RemotePostDetailRepository(apiClient: apiClient, postId: postId),
                                commentRepository: RemoteCommentRepository(apiClient: apiClient, postId: postId),
                                userInfoRepository: RemoteUserInfoRepository(apiClient: apiClient),
                                voteCardRepository: RemoteVoteCardRepository(apiClient: apiClient)
                            )
                        }
                    }
            }
            .environment(myPageRouter)
            .toolbar(myPageRouter.path.isEmpty ? .visible : .hidden, for: .tabBar)
            .tabItem { tabLabel(title: MainStrings.tabMyPage, icon: "PickpleUser", tag: 2) }
            .tag(2)
        }
        .tint(Color.navy60)
        // 탭을 떠날 때 그 탭의 네비게이션 스택을 비워둔다 — 그래야 다른 탭에 갔다가 다시
        // 돌아왔을 때 마지막에 보던 상세 화면이 아니라 항상 목록(루트)부터 보인다.
        .onChange(of: selectedTab) { oldValue, _ in
            // 애니메이션을 꺼도 안 됐다 — 문제는 우리 쪽 애니메이션이 아니라, 탭 전환
            // 트랜지션이 아직 화면에 보이는 도중에 리셋이 일어나 그 전환 중에 상세→목록
            // 전환이 그대로 보이는 것이었다. 탭 전환이 끝날 시간을 준 뒤(그 탭이 안 보이게
            // 된 뒤) 리셋하면 안 보이게 된다.
            Task {
                try? await Task.sleep(for: .milliseconds(400))
                switch oldValue {
                case 0: mainRouter.path.removeAll()
                case 1: communityRouter.path.removeAll()
                case 2: myPageRouter.path.removeAll()
                default: break
                }
            }
        }
    }

    // 탭 3개가 제목/아이콘만 다르고 나머지(선택 시 renderingMode 전환)는 동일해서 뽑았다.
    private func tabLabel(title: String, icon: String, tag: Int) -> some View {
        Label {
            Text(title)
        } icon: {
            Image(icon)
                .renderingMode(selectedTab == tag ? .template : .original)
        }
    }
}

#Preview {
    PickpleBottomNav()
}
