//
//  PickerRankingRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

struct PickerRankingRow: View {
    let ranking: PickerRanking

    private var medalImageName: String? {
        switch ranking.rank {
        case 1: return "Name=1st"
        case 2: return "Name=2st"
        case 3: return "Name=3st"
        default: return nil
        }
    }

    var body: some View {
        HStack(spacing: 6) {
            if let medalImageName {
                Image(medalImageName)
                    .resizable()
                    .frame(width: 28, height: 28)
            } else {
                Text("\(ranking.rank)")
                    .pickpleTypography(.title02)
                    .foregroundStyle(Color.neutral40) //임시
                    .frame(width: 28, height: 28)
            }

            AsyncImage(url: ranking.profileImageUrl) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Image("PickpleCharacter").resizable().scaledToFill()
            }
            .frame(width: 48, height: 48)
            .clipShape(Circle())

            HStack(spacing: 4) {
                Text(ranking.nickname)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.neutral100)

                Image("PickpleLevelBadge\(ranking.level)")
                    .resizable()
                    .frame(width: 20, height: 20)
            }

            Spacer()

            Text("\(ranking.points)P")
                .pickpleTypography(.body01)
                .foregroundStyle(Color.neutral100)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        PickerRankingRow(ranking: PickerRanking(id: UUID(), rank: 1, nickname: "닉네임", level: 5, profileImageUrl: nil, points: 1000))
        PickerRankingRow(ranking: PickerRanking(id: UUID(), rank: 4, nickname: "닉네임", level: 5, profileImageUrl: nil, points: 1000))
    }
    .padding()
}
