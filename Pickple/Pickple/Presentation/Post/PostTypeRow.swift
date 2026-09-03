//
//  PostTypeRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

// PostTypeSelectionSheet에서 쓰는 유형 한 줄(아이콘 + 타이틀).
struct PostTypeRow: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(icon)
                    .resizable()
                    .frame(width: 24, height: 24)

                Text(title)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.neutral100)

                Spacer()
            }
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    PostTypeRow(icon: "PickpleAgainst", title: PostViewStrings.forAgainstPickRowTitle, action: {})
        .padding(.horizontal, 20)
}
