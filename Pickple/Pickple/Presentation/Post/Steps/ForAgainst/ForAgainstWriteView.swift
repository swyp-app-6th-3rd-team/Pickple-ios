//
//  ForAgainstWriteView.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  찬반 픽 작성 순서: 카테고리·상품명(둘 다 필수, 처음부터 같이 보임) → 사진(필수) →
//  가격 → URL → 설명(선택, 하나씩 순차 공개). 다른 유형과 달리 상품명이 사진보다 먼저 온다.

import SwiftUI

struct ForAgainstWriteView: View {
    @Bindable var postViewModel: PostViewModel
    @Binding var isCategoryExpanded: Bool
    let categoryOptions: [String]

    private var isNameFilled: Bool { postViewModel.product.hasName }
    private var isPhotoFilled: Bool { postViewModel.product.hasPhoto }
    private var isPriceFilled: Bool { !postViewModel.product.price.isEmpty }
    private var isUrlFilled: Bool { !postViewModel.product.url.isEmpty }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(PostViewStrings.forAgainstStepOneTitle)
                .pickpleTypography(.heading02)

            CategoryFieldBlock(postViewModel: postViewModel, isExpanded: .constant(false), options: categoryOptions)
                .floatingOverSiblings {
                    CategoryFieldBlock(postViewModel: postViewModel, isExpanded: $isCategoryExpanded, options: categoryOptions)
                }

            // 수정 모드는 상품명/사진/가격/URL이 PATCH로 반영되지 않아(카테고리/제목/설명만
            // 지원) 원래 값을 보여주기만 하고 편집을 막는다 — 순차 공개도 건너뛰고 한꺼번에 보여준다.
            ProductNameFieldBlock(name: $postViewModel.product.name, maxLength: postViewModel.productNameMaxLength, isDisabled: postViewModel.isEditing)

            PhotoUploadFieldBlock(photos: $postViewModel.product.photos, maxCount: 3, hintText: PostViewStrings.photoHintUpToThree, isDisabled: postViewModel.isEditing)
                .revealed(postViewModel.isEditing || (postViewModel.isCategorySelected && isNameFilled))

            ProductPriceFieldBlock(price: $postViewModel.product.price, isDisabled: postViewModel.isEditing)
                .revealed(postViewModel.isEditing || (postViewModel.isCategorySelected && isNameFilled && isPhotoFilled))

            ProductURLFieldBlock(url: $postViewModel.product.url, isDisabled: postViewModel.isEditing)
                .revealed(postViewModel.isEditing || (postViewModel.isCategorySelected && isNameFilled && isPhotoFilled && isPriceFilled))

            DescriptionFieldBlock(text: $postViewModel.description, maxLength: postViewModel.descriptionMaxLength)
                .revealed(postViewModel.isEditing || (postViewModel.isCategorySelected && isNameFilled && isPhotoFilled && isPriceFilled && isUrlFilled))
        }
        .padding(.horizontal, 20)
        .animation(.easeInOut, value: postViewModel.isCategorySelected)
        .animation(.easeInOut, value: isNameFilled)
        .animation(.easeInOut, value: isPhotoFilled)
        .animation(.easeInOut, value: isPriceFilled)
        .animation(.easeInOut, value: isUrlFilled)
    }
}

#Preview {
    ScrollView {
        ForAgainstWriteView(
            postViewModel: PostViewModel(),
            isCategoryExpanded: .constant(false),
            categoryOptions: PostViewStrings.categoryOptions
        )
        .padding(.top, 32)
    }
}
