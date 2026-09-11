//
//  TopPickerRankingSection.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료 - 9월 12일

import SwiftUI

struct TopPickerRankingSection: View {
    let rankings: [PickerRanking]
    let onTapMore: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            //MARK: - Title
            HStack {
                Text(MainStrings.topRankingSectionTitle)
                    .pickpleTypography(.title01)
                    .foregroundStyle(Color.black)

                Spacer()

                Button(action: onTapMore) {
                    HStack(spacing: 4) {
                        Text(MainStrings.more)
                            .pickpleTypography(.body02)
                            .foregroundStyle(Color.neutral40)


                        Image("PickpleArrowRight")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color.neutral30)

                    }
                }
            }

            if rankings.isEmpty {
                Text(MainStrings.rankingEmptyMessage)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.neutral30)
                    .padding(.vertical, 60)
            } else {
                VStack(spacing: 0) {
                    ForEach(rankings) { ranking in
                        PickerRankingRow(ranking: ranking)
                            .padding(.vertical, 16)
                        
                        Divider()
                    }
                }
            }
        }
        .background(Color.white)
    }
}

#Preview {
    TopPickerRankingSection(rankings: [], onTapMore: {})
}
