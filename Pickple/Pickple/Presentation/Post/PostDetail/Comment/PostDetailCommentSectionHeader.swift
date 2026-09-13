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
    @Binding var sortOption: String
    @Binding var isSortExpanded: Bool

    var body: some View {
        HStack {
            Text(PostDetailStrings.commentCount(count))
                .pickpleTypography(.body01)
                .foregroundStyle(Color.black)

            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var sortOption = "최신순"
        @State private var isSortExpanded = false

        var body: some View {
            PostDetailCommentSectionHeader(count: 3, sortOption: $sortOption, isSortExpanded: $isSortExpanded)
                .padding()
        }
    }
    return PreviewWrapper()
}
