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
            HStack(spacing: 4) {
                switch type {
                case .text: Image("PickpleText").resizable().frame(width: 14, height: 14)
                case .forAgainst: Image("PickpleAgainst").resizable().frame(width: 14, height: 14)
                case .ab: Image("PickpleAB").resizable().frame(width: 14, height: 14)
                }

                Text(type.displayName)
                    .pickpleTypography(.caption)
                    .foregroundStyle(Color.green80)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Capsule().foregroundStyle(Color.green20))

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
