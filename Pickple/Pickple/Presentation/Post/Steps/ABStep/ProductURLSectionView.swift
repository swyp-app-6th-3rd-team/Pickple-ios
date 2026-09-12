//
//  ProductURLSectionView.swift
//  Pickple
//
//  Created by 박윤수 on 9/11/26.
//
// 1차 점검 완료 - 9월 12일

import SwiftUI

struct ProductURLSectionView: View {
    @Bindable var postViewModel: PostViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(PostViewStrings.url)
                .pickpleTypography(.body01)

            ProductURLFieldBlock(
                url: $postViewModel.productA.url,
                isDisabled: postViewModel.isEditing,
                AB: "A"
            )

            ProductURLFieldBlock(
                url: $postViewModel.productB.url,
                isDisabled: postViewModel.isEditing,
                AB: "B"
            )
        }
    }
}

#Preview {
    let postViewModel = PostViewModel()
    ProductURLSectionView(postViewModel: postViewModel)
        .padding()
}
