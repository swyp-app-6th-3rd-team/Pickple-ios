//
//  TopPickerRankingSection.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

struct TopPickerRankingSection: View {
    let rankings: [PickerRanking]
    let onTapMore: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            //MARK: - Title
            HStack {
                Text(MainStrings.topRankingSectionTitle)
                    .pickpleTypography(.title01)
                    .foregroundStyle(Color.neutral100)

                Spacer()

                Button(action: onTapMore) {
                    HStack(spacing: 4) {
                        Text(MainStrings.more)
                        Image(systemName: "chevron.right")
                    }
                    .pickpleTypography(.body02)
                    .foregroundStyle(Color.neutral40)
                }
            }

            if rankings.isEmpty {
                Text(MainStrings.rankingEmptyMessage)
                    .pickpleTypography(.body02)
                    .foregroundStyle(Color.neutral40)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            } else {
                VStack(spacing: 20) {
                    ForEach(rankings) { ranking in
                        PickerRankingRow(ranking: ranking)
                    }
                }
            }
        }
        .background(Color.white)
    }
}

#Preview {
    TopPickerRankingSection(rankings: [], onTapMore: {})
        .padding()
}
