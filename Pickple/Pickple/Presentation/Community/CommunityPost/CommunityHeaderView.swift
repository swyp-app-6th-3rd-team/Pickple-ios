//
//  CommunityHeaderView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료 - 9월 12일

import SwiftUI

struct CommunityHeaderView: View {
    @Bindable var communityViewModel: CommunityViewModel
    @Environment(CommunityRouter.self) private var communityRouter

    var body: some View {
        VStack(spacing: 0) {
            PickpleGNB(
                leading: .text(CommunityStrings.title),
                center: .none,
                trailing: .button(icon: Image("PickpleSearch"), action: { communityRouter.push(.search) })
            )

            CommunityCategoryRow(selectedCategory: $communityViewModel.selectedCategory)
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 8)

            HStack {
                PickpleSortButton(
                    isExpanded: .constant(false),
                    selectedValue: $communityViewModel.sortOption,
                    options: CommunityViewModel.sortOptions
                )
                .floatingOverSiblings {
                    PickpleSortButton(
                        isExpanded: $communityViewModel.isSortExpanded,
                        selectedValue: $communityViewModel.sortOption,
                        options: CommunityViewModel.sortOptions
                    )
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
    }
}

#Preview {
    CommunityHeaderView(communityViewModel: CommunityViewModel())
        .environment(CommunityRouter())
}
