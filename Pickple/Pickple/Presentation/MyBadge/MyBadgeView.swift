//
//  MyBadgeView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 그리드 간격/여백은 임시값
//

import SwiftUI

struct MyBadgeView: View {
    @StateObject var myBadgeViewModel: MyBadgeViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedBadge: MyBadge?
    @State private var newlyUnlockedBadge: MyBadge?

    private var badgeRows: [[MyBadge]] {
        stride(from: 0, to: myBadgeViewModel.badges.count, by: 3).map {
            Array(myBadgeViewModel.badges[$0..<min($0 + 3, myBadgeViewModel.badges.count)])
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            PickpleGNB(
                leading: .button(icon: Image("PickpleArrowLeft"), action: { dismiss() }),
                center: .text(MyBadgeStrings.title),
                trailing: .none
            )
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.neutral5)

                VStack(spacing: 24) {
                    VStack(spacing: 4) {
                        Text(MyBadgeStrings.collectionStatus)
                            .pickpleTypography(.title01)
                            .foregroundStyle(Color.black)

                        Text(MyBadgeStrings.collectedCount(myBadgeViewModel.unlockedCount))
                            .pickpleTypography(.body01)
                            .foregroundStyle(Color.neutral40)
                    }

                    VStack(spacing: 24) {
                        ForEach(badgeRows, id: \.[0].id) { row in
                            HStack {
                                ForEach(row) { badge in
                                    MyBadgeGridItem(badge: badge) {
                                        if !badge.isUnlocked {
                                            selectedBadge = badge
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            
            Spacer()
        }
        .task {
            await myBadgeViewModel.loadMyBadges()
            newlyUnlockedBadge = myBadgeViewModel.badges.first { $0.isNewlyUnlocked }
        }
        .sheet(item: $selectedBadge) { badge in
            MyBadgeUnlockConditionSheet(badge: badge) {
                selectedBadge = nil
            }
        }
        .sheet(item: $newlyUnlockedBadge) { badge in
            MyBadgeUnlockedCongratsModal(badge: badge) {
                newlyUnlockedBadge = nil
                //TODO: 확인 처리(서버에 확인 여부 반영 등) 연결 필요
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MyBadgeView(myBadgeViewModel: MyBadgeViewModel())
}
