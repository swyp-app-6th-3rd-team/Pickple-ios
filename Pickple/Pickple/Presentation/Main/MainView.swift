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
    @State private var isMissionExpanded = false
    @State private var navigatesToRanking = false

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        MainTitleView()
                        PickpleTabBar(tabs: ["찬반", "AB"], selectedIndex: mainViewModel.selectedTypeIndex)
                    }
                    .background(Color.navy60)
                    .onChange(of: mainViewModel.selectedType) { _, newValue in
                        cardStackViewModel.filterCards(by: newValue)
                    }

                    VStack(spacing: 24) {
                        CardStackView(cardStackViewModel: cardStackViewModel, onTapCard: { _ in
                            // TODO: 게시글 상세 연결 보류 — 작성/상세 화면 연결 작업과 한 번에 합류 예정
                        })
                        .frame(height: 440)
                        .padding(.top, 20)

                        BadgeMissionSection(
                            isLoggedIn: mainViewModel.isLoggedIn,
                            missions: mainViewModel.missions,
                            isExpanded: $isMissionExpanded
                        )

                        MainHotPostSection(
                            posts: mainViewModel.hotPosts,
                            onTapPost: { _ in
                                // TODO: 게시글 상세 연결 보류
                            },
                            onTapMore: {
                                // TODO: 커뮤니티 화면 연결 보류
                            }
                        )

                        TopPickerRankingSection(
                            rankings: mainViewModel.topRankings,
                            onTapMore: { navigatesToRanking = true }
                        )
                    }
                    .padding(20)
                }
            }

            if cardStackViewModel.showsLoginRequired {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                PickpleConfirmDialog(
                    title: "로그인이 필요해요",
                    description: "간편 로그인 후 더 많은 투표에\n참여해 보세요",
                    cancelTitle: "취소",
                    confirmTitle: "로그인",
                    onCancel: { cardStackViewModel.showsLoginRequired = false },
                    onConfirm: { cardStackViewModel.showsLoginRequired = false }
                )
                .padding(.horizontal, 40)
            }
        }
        .navigationDestination(isPresented: $navigatesToRanking) {
            MainRankingView()
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
}
