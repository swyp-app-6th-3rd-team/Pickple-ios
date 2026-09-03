//
//  PickerRankingRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 프로필 사진 없을 때 아바타는 임시 시스템 아이콘

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
        HStack(spacing: 12) {
            if let medalImageName {
                Image(medalImageName)
                    .resizable()
                    .frame(width: 24, height: 24)
            } else {
                Text("\(ranking.rank)")
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.neutral40)
                    .frame(width: 24)
            }

            if let profileImageName = ranking.profileImageName {
                Image(profileImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(Color.neutral20)
            }

            HStack(spacing: 4) {
                Text(ranking.nickname)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.black)

                Image("PickpleLevelBadge\(ranking.level)")
                    .resizable()
                    .frame(width: 16, height: 16)
            }

            Spacer()

            Text("\(ranking.points)P")
                .pickpleTypography(.body01)
                .foregroundStyle(Color.black)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        PickerRankingRow(ranking: PickerRanking(id: UUID(), rank: 1, nickname: "닉네임", level: 5, profileImageName: nil, points: 1000))
        PickerRankingRow(ranking: PickerRanking(id: UUID(), rank: 4, nickname: "닉네임", level: 5, profileImageName: nil, points: 1000))
    }
    .padding()
}
