//
//  PostDetailCommentSectionHeader.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료 - 9월 12일

import SwiftUI

struct PostDetailCommentSectionHeader: View {
    let count: Int

    var body: some View {
        HStack {
            Text(PostDetailStrings.commentCount(count))
                .pickpleTypography(.body01_500)
                .foregroundStyle(Color.black)

            Spacer()
        }
        .padding(4)
    }
}

#Preview {
    PostDetailCommentSectionHeader(count: 3)
        .padding()
}
