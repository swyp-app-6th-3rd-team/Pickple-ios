//
//  PostDetailMenuRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  1차 점검 완료 - 9월 13일

import SwiftUI

// 게시글/댓글 더보기 바텀시트에서 공통으로 쓰는 한 줄(아이콘 + 타이틀).
struct PostDetailMenuRow: View {
    let icon: String
    let title: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(icon)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(tint)

                Text(title)
                    .pickpleTypography(.body01)
                    .foregroundStyle(tint)

                Spacer()
            }
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    PostDetailMenuRow(icon: "PickpleModify", title: "수정하기", tint: Color.neutral100, action: {})
        .padding()
}
