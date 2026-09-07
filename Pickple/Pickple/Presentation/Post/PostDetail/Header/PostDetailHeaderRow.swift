//
//  PostDetailHeaderRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

// 게시글 유형 배지 + 더보기(⋮) 메뉴 버튼.
struct PostDetailHeaderRow: View {
    let type: VoteType
    let onMoreTapped: () -> Void

    var body: some View {
        HStack {
            PostTypeBadge(type: type, iconSize: 14, typography: .caption, textColor: .green80, backgroundColor: .green20)

            Spacer()

            Button(action: onMoreTapped) {
                Image(systemName: "ellipsis")
                    .foregroundStyle(Color.neutral50)
            }
        }
    }
}

#Preview {
    PostDetailHeaderRow(type: .forAgainst, onMoreTapped: {})
        .padding()
}
