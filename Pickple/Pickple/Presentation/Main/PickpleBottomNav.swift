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
    @State private var selectedTab = 0
    @State private var mainRouter = MainRouter()
    @State private var communityRouter = CommunityRouter()
    @State private var myPageRouter = MyPageRouter()
    @StateObject private var myPageViewModel = MyPageViewModel()

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $mainRouter.path) {
                MainView(onRequestCommunityTab: { selectedTab = 1 })
                    .navigationDestination(for: MainRoute.self) { route in
                        switch route {
                        case .postDetail(let type):
                            PostDetailView(voteType: type)
                        case .ranking:
                            MainRankingView()
                        }
                    }
            }
            .environment(mainRouter)
            .tabItem {
                Label {
                    Text("홈")
                } icon: {
                    Image("PickpleHome")
                        .renderingMode(selectedTab == 0 ? .template : .original)
                }
            }
            .tag(0)

            NavigationStack(path: $communityRouter.path) {
                CommunityView(communityViewModel: CommunityViewModel())
                    .navigationDestination(for: CommunityRoute.self) { route in
                        switch route {
                        case .postDetail(let type):
                            PostDetailView(voteType: type)
                        }
                    }
            }
            .environment(communityRouter)
            .tabItem {
                Label {
                    Text("커뮤니티")
                } icon: {
                    Image("PickpleMessage")
                        .renderingMode(selectedTab == 1 ? .template : .original)
                }
            }
            .tag(1)

            NavigationStack(path: $myPageRouter.path) {
                MyPageView(myPageViewModel: myPageViewModel)
                    .navigationDestination(for: MyPageRoute.self) { route in
                        switch route {
                        case .grade:
                            MyGradeView(myPageViewModel: myPageViewModel)
                        case .badge:
                            MyBadgeView(myBadgeViewModel: MyBadgeViewModel())
                        case .account:
                            MyAccountView()
                        case .activity:
                            MyActivityView(myActivityViewModel: MyActivityViewModel())
                        case .postDetail(let type):
                            PostDetailView(voteType: type)
                        }
                    }
            }
            .environment(myPageRouter)
            .tabItem {
                Label {
                    Text("마이")
                } icon: {
                    Image("PickpleUser")
                        .renderingMode(selectedTab == 2 ? .template : .original)
                }
            }
            .tag(2)
        }
        .tint(Color.navy60)
    }
}

#Preview {
    PickpleBottomNav()
}
