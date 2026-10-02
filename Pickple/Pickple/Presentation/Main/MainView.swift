//
//  MainView.swift
//  Pickple
//
//  Created by 박윤수 on 8/28/26.
//
// 1차 점검 완료 - 9월 12일

import SwiftUI

struct MainView: View {
    @State private var mainViewModel: MainViewModel
    @State private var cardStackViewModel: CardStackViewModel
    @Environment(MainRouter.self) private var mainRouter
    @Environment(\.showLoginPrompt) private var showLoginPrompt
    @State private var isMissionExpanded = false
    var onRequestCommunityTab: (() -> Void)? = nil
    // 아래로 스크롤하면 하단 탭바를 숨기는 데 쓴다 — PickpleTabView가 이걸로 전달받아
    // .toolbar(_, for: .tabBar) 노출 여부에 같이 반영한다.
    var isScrolledDown: Binding<Bool> = .constant(false)

    init(
        mainViewModel: MainViewModel = MainViewModel(),
        cardStackViewModel: CardStackViewModel = CardStackViewModel(),
        onRequestCommunityTab: (() -> Void)? = nil,
        isScrolledDown: Binding<Bool> = .constant(false)
    ) {
        _mainViewModel = State(initialValue: mainViewModel)
        _cardStackViewModel = State(initialValue: cardStackViewModel)
        self.onRequestCommunityTab = onRequestCommunityTab
        self.isScrolledDown = isScrolledDown
    }
    
    var body: some View {
        ZStack {
                Color.white
                    .ignoresSafeArea()
            
            VStack(spacing: 0) {
                MainTitle(selectedType: $mainViewModel.selectedType)
                    .onChange(of: mainViewModel.selectedType) { _, newValue in
                        cardStackViewModel.filterCards(by: newValue)
                    }

                ScrollView {
                    VStack(spacing: 0) {
                        CardStackView(
                            cardStackViewModel: cardStackViewModel,
                            onTapCard: { card in
                                mainRouter.push(.postDetail(postId: card.id, type: card.type))
                            },
                            onVoteCompleted: {
                                Task { await mainViewModel.reloadMissions() }
                            }
                        )
                        .padding(.top, 30) //윗 간격
                        .padding(.horizontal, 20)

                        BadgeMissionSection(
                            isLoggedIn: mainViewModel.isLoggedIn,
                            missions: mainViewModel.missions,
                            isExpanded: $isMissionExpanded,
                            onLoginTapped: { showLoginPrompt(.main) }
                        )
                        .padding(.top, 30) //카드 + 미션 간격
                        .padding(.horizontal, 20)

                        MainHotPostSection(
                            posts: mainViewModel.hotPosts,
                            onTapPost: { post in
                                mainRouter.push(.postDetail(postId: post.id, type: post.type))
                            },
                            onTapMore: {
                                onRequestCommunityTab?()
                            }
                        )
                        .padding(.top, 50) //미션 + 핫투표 간격

                        TopPickerRankingSection(
                            rankings: mainViewModel.topRankings,
                            onTapMore: { mainRouter.push(.ranking) }
                        )
                        .padding(.top, 50) //핫투표 + 랭킹 간격
                        .padding(.horizontal, 20)
                    }
                    
                }
                .onTabBarHideScroll(isScrolledDown: isScrolledDown)
                // 카드스택을 한 번 불러온 뒤로는 재사용하도록 바꿔서, 새 카드를 보고 싶을 때
                // 쓸 수 있는 수단이 없어졌다 — 당겨서 새로고침으로 직접 다시 뽑을 수 있게 한다.
                .refreshable {
                    await cardStackViewModel.refreshCards()
                }
            }
        }
        // 게스트가 카드에 투표하면 CardStackViewModel이 showsLoginRequired를 켠다 —
        // 다이얼로그는 탭바까지 덮도록 PickpleTabView가 그리므로 요청만 넘기고 바로 끈다.
        .onChange(of: cardStackViewModel.showsLoginRequired) { _, shows in
            guard shows else { return }
            cardStackViewModel.showsLoginRequired = false
            showLoginPrompt(.main)
        }
        // .task는 이 화면이 처음 생성될 때 딱 한 번만 실행된다 — 게시글 상세 등 다른 화면에서
        // 투표하고 홈으로 돌아와도 카드스택은 그 변화를 몰라 예전(미투표) 상태 그대로 남는
        // 문제가 있었다. .onAppear로 바꿔서 홈 탭에 다시 보일 때마다 새로 불러온다.
        .onAppear {
            Task {
                await cardStackViewModel.loadCards()
                cardStackViewModel.filterCards(by: mainViewModel.selectedType)
                await cardStackViewModel.loadMyProfileImage()
                await mainViewModel.loadHomeData()
            }
        }
    }
}

#Preview {
    NavigationStack {
        MainView()
    }
    .environment(MainRouter())
}
