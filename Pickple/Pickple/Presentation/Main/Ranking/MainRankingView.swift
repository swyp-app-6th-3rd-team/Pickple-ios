//
//  MainRankingView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 본인 랭킹은 스크롤로 도달 시 리스트에 합쳐져야 하는데,
//  지금은 하단에 항상 고정된 바로 단순화해서 구현함.

import SwiftUI

struct MainRankingView: View {
    @StateObject private var mainRankingViewModel = MainRankingViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            PickpleGNB(
                leading: .button(icon: Image("PickpleArrowLeft"), action: { dismiss() }),
                center: .text(MainStrings.rankingTitle),
                trailing: .none
            )

            if mainRankingViewModel.rankings.isEmpty {
                Spacer()
                Text(MainStrings.rankingEmptyMessage)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.neutral40)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(mainRankingViewModel.rankings) { ranking in
                            PickerRankingRow(ranking: ranking)
                                .task { await mainRankingViewModel.loadMoreIfNeeded(currentItem: ranking) }
                        }
                    }
                    .padding(20)
                }

                if mainRankingViewModel.isLoggedIn {
                    Divider()
                    PickerRankingRow(ranking: mainRankingViewModel.myRanking)
                        .padding(20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await mainRankingViewModel.loadInitial()
        }
    }
}

#Preview {
    NavigationStack {
        MainRankingView()
    }
}
