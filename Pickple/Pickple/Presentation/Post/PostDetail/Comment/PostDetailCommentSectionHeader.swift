//
//  PostDetailCommentSectionHeader.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

struct PostDetailCommentSectionHeader: View {
    let count: Int
    @Binding var sortOption: String
    @Binding var isSortExpanded: Bool

    var body: some View {
        HStack {
            Text(PostDetailStrings.commentCount(count))
                .pickpleTypography(.body01)
                .foregroundStyle(Color.neutral100)

            Spacer()

            PickpleSortButton(
                isExpanded: .constant(false),
                selectedValue: $sortOption,
                options: PostDetailViewModel.sortOptions,
                alignment: .trailing
            )
            .floatingOverSiblings(alignment: .topTrailing) {
                PickpleSortButton(
                    isExpanded: $isSortExpanded,
                    selectedValue: $sortOption,
                    options: PostDetailViewModel.sortOptions,
                    alignment: .trailing
                )
            }
        }
        .zIndex(1)
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
