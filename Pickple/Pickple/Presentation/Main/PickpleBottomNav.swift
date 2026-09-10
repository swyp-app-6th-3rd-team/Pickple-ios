//
//  PickpleBottomNav.swift
//  Pickple
//
//  Created by 박윤수 on 8/28/26.
//
//  아이콘 에셋 하나(비선택 색이 고정으로 박혀있는 원본)만 두고,
//  renderingMode를 선택 여부에 따라 바꾼다.
//  - 비선택: .original → 에셋에 박힌 원래 색 그대로
//  - 선택: .template → 알파만 남아서 .tint()가 적용됨
//  이러면 .tint()가 실제로 선택된 탭에만 영향을 주고, 비선택 탭은 항상
//  에셋 고유 색을 유지한다. PickpleHomeSelected 같은 별도 에셋도 필요 없다.
//
//  탭마다 독립된 NavigationStack을 둔다 — 각 탭 내부(MainView/CommunityView/MyPageView)의
//  .navigationDestination이 동작하려면 그 탭 전용 NavigationStack이 필요하다.
//  .tabItem/.tag는 TabView가 자기 바로 아래 자식에서 찾으므로 NavigationStack
//  안쪽이 아니라 바깥쪽에 붙여야 한다.

import SwiftUI

struct PickpleBottomNav: View {
    @Environment(\.apiClient) private var apiClient
    @Environment(\.isLoggedIn) private var isLoggedIn
    @Environment(GuestVoteTracker.self) private var guestVoteTracker
    @State private var selectedTab = 0
    @State private var mainRouter = MainRouter()
    @State private var communityRouter = CommunityRouter()
    @State private var myPageRouter = MyPageRouter()
    @State private var myPageViewModel: MyPageViewModel

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
                    cardStackViewModel: CardStackViewModel(voteCardRepository: RemoteVoteCardRepository(apiClient: apiClient), userInfoRepository: RemoteUserInfoRepository(apiClient: apiClient), isLoggedIn: isLoggedIn, guestVoteTracker: guestVoteTracker),
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
                                voteCardRepository: RemoteVoteCardRepository(apiClient: apiClient),
                                guestVoteTracker: guestVoteTracker
                            )
                        case .ranking:
                            MainRankingView(mainRankingViewModel: MainRankingViewModel(pickerRankingRepository: RemotePickerRankingRepository(apiClient: apiClient), isLoggedIn: isLoggedIn))
                        }
                    }
            }
            .environment(mainRouter)
            .tabItem { tabLabel(title: MainStrings.tabHome, icon: "PickpleHome", tag: 0) }
            .tag(0)

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
                                voteCardRepository: RemoteVoteCardRepository(apiClient: apiClient),
                                guestVoteTracker: guestVoteTracker
                            )
                        case .search:
                            CommunitySearchView(communitySearchViewModel: CommunitySearchViewModel(communityRepository: RemoteCommunityRepository(apiClient: apiClient)))
                        }
                    }
            }
            .environment(communityRouter)
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
                        case .activity:
                            MyActivityView(myActivityViewModel: MyActivityViewModel(userPostRepository: RemoteUserPostRepository(apiClient: apiClient)))
                        case .postDetail(let postId, let type):
                            PostDetailView(
                                voteType: type,
                                postDetailRepository: RemotePostDetailRepository(apiClient: apiClient, postId: postId),
                                commentRepository: RemoteCommentRepository(apiClient: apiClient, postId: postId),
                                userInfoRepository: RemoteUserInfoRepository(apiClient: apiClient),
                                voteCardRepository: RemoteVoteCardRepository(apiClient: apiClient),
                                guestVoteTracker: guestVoteTracker
                            )
                        }
                    }
            }
            .environment(myPageRouter)
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
