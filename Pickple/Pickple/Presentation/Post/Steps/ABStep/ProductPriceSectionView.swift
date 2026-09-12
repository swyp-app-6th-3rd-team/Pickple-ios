//
//  ProductPriceSectionView.swift
//  Pickple
//
//  Created by 박윤수 on 9/11/26.
//
// 1차 점검 완료 - 9월 12일

import SwiftUI

struct ProductPriceSectionView: View {
    @Bindable var postViewModel: PostViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(PostViewStrings.price)
                .pickpleTypography(.body01)

            ProductPriceFieldBlock(
                price: $postViewModel.productA.price,
                isDisabled: postViewModel.isEditing,
                AB: "A"
            )

            ProductPriceFieldBlock(
                price: $postViewModel.productB.price,
                isDisabled: postViewModel.isEditing,
                AB: "B"
            )
        }
    }
}

#Preview {
    let postViewModel = PostViewModel()
    ProductPriceSectionView(postViewModel: postViewModel)
        .padding()
}
