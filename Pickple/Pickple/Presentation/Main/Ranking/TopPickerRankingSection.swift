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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("TOP 피커 랭킹")
                    .pickpleTypography(.title02)
                    .foregroundStyle(Color.black)

                Spacer()

                Button(action: onTapMore) {
                    HStack(spacing: 2) {
                        Text("더보기")
                        Image(systemName: "chevron.right")
                    }
                    .pickpleTypography(.caption)
                    .foregroundStyle(Color.neutral40)
                }
            }

            if rankings.isEmpty {
                Text("아직 TOP 피커가 존재하지 않아요")
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
    }
}

#Preview {
    TopPickerRankingSection(rankings: [], onTapMore: {})
        .padding()
}
