//
//  MainRankingGuestRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  게스트가 랭킹 화면에서 보는 자리표시자 행. 일반 랭킹 행과 같은 레이아웃(순위/프로필/닉네임)을
//  쓰되, 게스트는 실제 순위가 없으니 그 자리는 "-"로 채우고 포인트 자리만 로그인 유도 버튼으로 바꾼다.

import SwiftUI

struct MainRankingGuestRow: View {
    let onLoginTapped: () -> Void

    var body: some View {
        HStack(spacing: 6) {
            HStack(spacing: 6) {
                Text("-")
                    .pickpleTypography(.title02)
                    .foregroundStyle(Color.neutral40)
                    .frame(width: 28, height: 28)

                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .foregroundStyle(Color.neutral20)

                Text(MainStrings.rankingGuestNickname)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.neutral100)
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
                            .foregroundStyle(Color.neutral100))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

#Preview {
    MainRankingGuestRow(onLoginTapped: {})
        .padding()
}
