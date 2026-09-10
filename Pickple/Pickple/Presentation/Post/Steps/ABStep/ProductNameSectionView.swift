//
//  ProductNameSectionView.swift
//  Pickple
//
//  Created by 박윤수 on 9/11/26.
//

import SwiftUI

struct ProductNameSectionView: View {
    @Bindable var postViewModel: PostViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            (
                Text(PostViewStrings.productName) +
                Text(" ") +
                Text(PostViewStrings.requiredMark)
                    .foregroundStyle(Color.red60)
            )
            .pickpleTypography(.body01)

            ProductNameFieldBlock(
                name: $postViewModel.productA.name,
                maxLength: postViewModel.productNameMaxLength,
                isDisabled: postViewModel.isEditing
            )

            ProductNameFieldBlock(
                name: $postViewModel.productB.name,
                maxLength: postViewModel.productNameMaxLength,
                isDisabled: postViewModel.isEditing
            )
        }
        .opacity(postViewModel.isEditing ? 0.5 : 1)
    }
}

#Preview {
    let postViewModel = PostViewModel()
    ProductNameSectionView(postViewModel: postViewModel)
}
