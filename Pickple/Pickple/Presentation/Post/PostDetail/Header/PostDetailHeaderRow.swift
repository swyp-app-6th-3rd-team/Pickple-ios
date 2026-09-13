//
//  PostDetailHeaderRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료 - 9월 13일

import SwiftUI

// 게시글 유형 배지 + 더보기(⋮) 메뉴 버튼.
struct PostDetailHeaderRow: View {
    let type: VoteType
    let onMoreTapped: () -> Void

    var body: some View {
        HStack {
            PostTypeBadge(type: type, iconSize: 16, typography: .label, textColor: Color.neutral40, backgroundColor: .white)
                .background(
                    PostTypeBadge(type: type, iconSize: 16, typography: .label, textColor: Color.neutral40, backgroundColor: .white, stroke: true, strokeColor: .navy10)
                )

            Spacer()

            Button(action: onMoreTapped) {
                Image("PickpleMenu")
                    .foregroundStyle(Color.neutral50)
            }
        }
    }
}

#Preview {
    PostDetailHeaderRow(type: .forAgainst, onMoreTapped: {})
        .padding()
}
