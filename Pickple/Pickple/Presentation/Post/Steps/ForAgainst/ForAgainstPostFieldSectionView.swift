//
//  ForAgainstPostFieldSectionView.swift
//  Pickple
//
//  Created by 박윤수 on 9/11/26.
//

import SwiftUI

struct ForAgainstPostFieldSectionView: View {
    @Bindable var postViewModel: PostViewModel
    @Binding var isCategoryExpanded: Bool
    let categoryOptions: [String]
    
    private var isNameFilled: Bool { postViewModel.product.hasName }
    private var isPhotoFilled: Bool { postViewModel.product.hasPhoto }
    private var isPriceFilled: Bool { !postViewModel.product.price.isEmpty }
    private var isUrlFilled: Bool { !postViewModel.product.url.isEmpty }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            CategoryFieldBlock(postViewModel: postViewModel, isExpanded: .constant(false), options: categoryOptions)
                .floatingOverSiblings {
                    CategoryFieldBlock(postViewModel: postViewModel, isExpanded: $isCategoryExpanded, options: categoryOptions)
                }
            
            // 수정 모드는 상품명/사진/가격/URL이 PATCH로 반영되지 않아(카테고리/제목/설명만
            // 지원) 원래 값을 보여주기만 하고 편집을 막는다 — 순차 공개도 건너뛰고 한꺼번에 보여준다.
            VStack(alignment: .leading, spacing: 8) {
                (
                    Text(PostViewStrings.productName) +
                    Text(" ") +
                    Text(PostViewStrings.requiredMark)
                        .foregroundStyle(Color.red60)
                )
                .pickpleTypography(.body01)

                ProductNameFieldBlock(name: $postViewModel.product.name, maxLength: postViewModel.productNameMaxLength, isDisabled: postViewModel.isEditing)
            }
            .opacity(postViewModel.isEditing ? 0.5 : 1)
            
            PhotoUploadSectionView(photos: $postViewModel.product.photos, maxCount: 3, hintText: PostViewStrings.photoHintUpToThree, isDisabled: postViewModel.isEditing)
                .revealed(postViewModel.isEditing || (postViewModel.isCategorySelected && isNameFilled))
            
            ProductPriceFieldBlock(price: $postViewModel.product.price, isDisabled: postViewModel.isEditing)
                .revealed(postViewModel.isEditing || (postViewModel.isCategorySelected && isNameFilled && isPhotoFilled))
            
            ProductURLFieldBlock(url: $postViewModel.product.url, isDisabled: postViewModel.isEditing)
                .revealed(postViewModel.isEditing || (postViewModel.isCategorySelected && isNameFilled && isPhotoFilled && isPriceFilled))
            
            DescriptionFieldBlock(text: $postViewModel.description, maxLength: postViewModel.descriptionMaxLength)
                .revealed(postViewModel.isEditing || (postViewModel.isCategorySelected && isNameFilled && isPhotoFilled && isPriceFilled && isUrlFilled))
        }
        .animation(.easeInOut, value: postViewModel.isCategorySelected)
        .animation(.easeInOut, value: isNameFilled)
        .animation(.easeInOut, value: isPhotoFilled)
        .animation(.easeInOut, value: isPriceFilled)
        .animation(.easeInOut, value: isUrlFilled)
    }
}


#Preview {
    ForAgainstPostFieldSectionView(
        postViewModel: PostViewModel(),
        isCategoryExpanded: .constant(false),
        categoryOptions: PostViewStrings.categoryOptions
    )
}
