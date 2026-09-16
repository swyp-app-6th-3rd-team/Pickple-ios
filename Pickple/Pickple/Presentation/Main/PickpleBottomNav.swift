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
    // 홈/커뮤니티/마이페이지 각 화면이 스크롤 위치에 따라 이 값을 바꾸면, 아래 커스텀 바가
    // offset(y:)로 실제로 위아래로 슬라이드한다.
    @State private var tabBarVisibility = TabBarVisibilityController()

    init(myPageViewModel: MyPageViewModel = MyPageViewModel()) {
        _myPageViewModel = State(initialValue: myPageViewModel)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            tabContent
            CustomTabBar(selectedTab: $selectedTab)
                .offset(y: tabBarVisibility.isHidden ? CustomTabBar.height + 40 : 0)
                .animation(.easeInOut(duration: 0.2), value: tabBarVisibility.isHidden)
        }
        .environment(tabBarVisibility)
        .tint(Color.navy60)
    }

    // TabView는 .tabItem으로 만든 네이티브 탭바가 항상 같이 딸려 온다 — .toolbar(.hidden,
    // for: .tabBar)로 숨겨봐도 실제로는 존재만 하고 안 보이는 것뿐이라(그리고 그 "숨기기"
    // 자체도 거는 위치에 따라 안 먹히는 경우가 있었다), 우리 커스텀 바랑 겹쳐 보이는 문제가
    // 계속 반복됐다. 그래서 TabView를 아예 안 쓰고, 3개 화면을 전부 동시에 살려둔 채
    // opacity/hitTesting으로만 전환한다 — 네이티브 탭바 자체가 존재하지 않으니 숨길 필요도
    // 없고, 탭을 오갈 때 각 화면의 상태(스크롤 위치 등)도 화면이 파괴되지 않아 그대로 유지된다.
    private var tabContent: some View {
        ZStack {
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
            .opacity(selectedTab == 0 ? 1 : 0)
            .allowsHitTesting(selectedTab == 0)
            .accessibilityHidden(selectedTab != 0)

            NavigationStack(path: $communityRouter.path) {
                CommunityView(communityViewModel: CommunityViewModel(communityRepository: RemoteCommunityRepository(apiClient: apiClient)))
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
            .opacity(selectedTab == 1 ? 1 : 0)
            .allowsHitTesting(selectedTab == 1)
            .accessibilityHidden(selectedTab != 1)

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
                        case .activity:
                            MyActivityView(myActivityViewModel: MyActivityViewModel(userPostRepository: RemoteUserPostRepository(apiClient: apiClient)))
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
            .opacity(selectedTab == 2 ? 1 : 0)
            .allowsHitTesting(selectedTab == 2)
            .accessibilityHidden(selectedTab != 2)
        }
        // 콘텐츠가 항상 CustomTabBar 높이만큼 안전 영역을 갖도록 자리만 비워둔다
        // (실제로 보이는 바는 위 ZStack의 CustomTabBar가 그 위에 겹쳐서 그린다).
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: CustomTabBar.height)
        }
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
}

#Preview {
    PickpleBottomNav()
}
