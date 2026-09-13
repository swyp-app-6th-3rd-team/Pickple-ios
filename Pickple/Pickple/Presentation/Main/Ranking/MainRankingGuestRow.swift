//
//  MainRankingGuestRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
// 1차 점검 완료 - 9월 12일
// "-" 폰트 미지정(폰트가 맞는지도 확인 필요)

import SwiftUI

struct MainRankingGuestRow: View {
    let onLoginTapped: () -> Void

    var body: some View {
        HStack(spacing: 6) {
            HStack(spacing: 6) {
                Text("-")
                    .pickpleTypography(.title02) // 폰트 미지정(폰트가 맞나?)
                    .foregroundStyle(Color.neutral40)
                    .frame(width: 28, height: 28)

                Image("PickpleCharacter")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())

                Text(MainStrings.rankingGuestNickname)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.black)
            }

            Spacer()

            Button(action: onLoginTapped) {
                Text(MainStrings.rankingGuestLoginCTA)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color.black))
            }
        }
    }
}

#Preview {
    MainRankingGuestRow(onLoginTapped: {})
}
