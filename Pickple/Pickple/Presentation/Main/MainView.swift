//
//  MainView.swift
//  Pickple
//
//  Created by 박윤수 on 8/28/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 카드/핫한 투표 탭 시 상세 화면 진입은 보류(연결 로직 미정)

import SwiftUI

struct MainView: View {
    @State private var mainViewModel: MainViewModel
    @State private var cardStackViewModel: CardStackViewModel
    @Environment(MainRouter.self) private var mainRouter
    @Environment(\.appRequestLogin) private var appRequestLogin
    @State private var isMissionExpanded = false
    @State private var showsBadgeLoginRequired = false
    var onRequestCommunityTab: (() -> Void)? = nil

    init(
        mainViewModel: MainViewModel = MainViewModel(),
        cardStackViewModel: CardStackViewModel = CardStackViewModel(),
        onRequestCommunityTab: (() -> Void)? = nil
    ) {
        _mainViewModel = State(initialValue: mainViewModel)
        _cardStackViewModel = State(initialValue: cardStackViewModel)
        self.onRequestCommunityTab = onRequestCommunityTab
    }

    var body: some View {
        ZStack {
            VStack {
                Color.white
                    .ignoresSafeArea()
            }

            ScrollView {
                VStack {
                    VStack {
                        MainTitleView(isOn: mainViewModel.isABSelected)
                            .padding(.horizontal, 20)
                    }
                    .onChange(of: mainViewModel.selectedType) { _, newValue in
                        cardStackViewModel.filterCards(by: newValue)
                    }
                    
                    Divider()

                    VStack(spacing: 50) {
                        VStack(spacing: 30) {
                            CardStackView(
                                cardStackViewModel: cardStackViewModel,
                                onTapCard: { card in
                                    mainRouter.push(.postDetail(postId: card.id, type: card.type))
                                },
                                onVoteCompleted: {
                                    Task { await mainViewModel.reloadMissions() }
                                }
                            )
                            .padding(.top, 30)
                            
                            BadgeMissionSection(
                                isLoggedIn: mainViewModel.isLoggedIn,
                                missions: mainViewModel.missions,
                                isExpanded: $isMissionExpanded,
                                onLoginTapped: { showsBadgeLoginRequired = true }
                            )
                        }

                        MainHotPostSection(
                            posts: mainViewModel.hotPosts,
                            onTapPost: { post in
                                mainRouter.push(.postDetail(postId: post.id, type: post.type))
                            },
                            onTapMore: {
                                onRequestCommunityTab?()
                            }
                        )

                        TopPickerRankingSection(
                            rankings: mainViewModel.topRankings,
                            onTapMore: { mainRouter.push(.ranking) }
                        )
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                }
            }

            if cardStackViewModel.showsLoginRequired {
                PickpleDialogOverlay {
                    PickpleConfirmDialog(
                        title: MainStrings.loginRequiredTitle,
                        description: MainStrings.loginRequiredDescription,
                        cancelTitle: MainStrings.cancel,
                        confirmTitle: MainStrings.login,
                        onCancel: { cardStackViewModel.showsLoginRequired = false },
                        onConfirm: {
                            cardStackViewModel.showsLoginRequired = false
                            appRequestLogin()
                        }
                    )
                }
            }

            if showsBadgeLoginRequired {
                PickpleDialogOverlay {
                    PickpleConfirmDialog(
                        title: MainStrings.loginRequiredTitle,
                        description: MainStrings.loginRequiredDescription,
                        cancelTitle: MainStrings.cancel,
                        confirmTitle: MainStrings.login,
                        onCancel: { showsBadgeLoginRequired = false },
                        onConfirm: {
                            showsBadgeLoginRequired = false
                            appRequestLogin()
                        }
                    )
                }
            }
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
