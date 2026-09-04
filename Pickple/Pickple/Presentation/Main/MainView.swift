//
//  MainView.swift
//  Pickple
//
//  Created by 박윤수 on 8/28/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 카드/핫한 투표 탭 시 상세 화면 진입은 보류(연결 로직 미정)

import SwiftUI

struct MainView: View {
    @StateObject private var mainViewModel = MainViewModel()
    @StateObject private var cardStackViewModel = CardStackViewModel()
    @Environment(MainRouter.self) private var mainRouter
    @State private var isMissionExpanded = false
    var onRequestCommunityTab: (() -> Void)? = nil

    var body: some View {
        ZStack {
            VStack {
                Color.navy60
                    .ignoresSafeArea()
                Color.white
                    .ignoresSafeArea()
            }

            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        MainTitleView()

                        PickpleTabBar(
                            tabs: MainStrings.voteTypeTabs,
                            selectedIndex: mainViewModel.selectedTypeIndex,
                            selectedColor: .white,
                            unselectedColor: Color.neutral20
                        )
                    }
                    .onChange(of: mainViewModel.selectedType) { _, newValue in
                        cardStackViewModel.filterCards(by: newValue)
                    }

                    VStack(spacing: 50) {
                        VStack(spacing: 30) {
                            CardStackView(cardStackViewModel: cardStackViewModel, onTapCard: { card in
                                mainRouter.push(.postDetail(card.type))
                            })
                            .padding(.top, 30)
                            
                            BadgeMissionSection(
                                isLoggedIn: mainViewModel.isLoggedIn,
                                missions: mainViewModel.missions,
                                isExpanded: $isMissionExpanded
                            )
                        }

                        MainHotPostSection(
                            posts: mainViewModel.hotPosts,
                            onTapPost: { post in
                                mainRouter.push(.postDetail(post.type))
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
                        onConfirm: { cardStackViewModel.showsLoginRequired = false }
                    )
                }
            }
        }
        .task {
            await cardStackViewModel.loadCards()
            cardStackViewModel.filterCards(by: mainViewModel.selectedType)
            await mainViewModel.loadHomeData()
        }
    }
}

#Preview {
    NavigationStack {
        MainView()
    }
    .environment(MainRouter())
}
