//
//  ABWriteView.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
// 1차 점검 완료 - 9월 12일

import SwiftUI

struct ABWriteView: View {
    @Bindable var postViewModel: PostViewModel
    @Binding var isCategoryExpanded: Bool
    let categoryOptions: [String]

    private var isANameFilled: Bool { postViewModel.productA.hasName }
    private var isBNameFilled: Bool { postViewModel.productB.hasName }
    private var areNamesFilled: Bool { isANameFilled && isBNameFilled }

    private var arePhotosFilled: Bool { postViewModel.productA.hasPhoto && postViewModel.productB.hasPhoto }
    private var arePricesFilled: Bool { !postViewModel.productA.price.isEmpty && !postViewModel.productB.price.isEmpty }
    private var areUrlsFilled: Bool { !postViewModel.productA.url.isEmpty && !postViewModel.productB.url.isEmpty }

    // 카테고리·주제까지 채워야 상품명 섹션 다음 단계로 넘어간다("기본"으로 같이 보이는 건 상품명까지).
    private var isBasicInfoFilled: Bool {
        postViewModel.isCategorySelected && postViewModel.isTopicFilled
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(PostViewStrings.abStepOneTitle)
                .pickpleTypography(.heading02)

            CategoryFieldBlock(postViewModel: postViewModel, isExpanded: .constant(false), options: categoryOptions)
                .floatingOverSiblings {
                    CategoryFieldBlock(postViewModel: postViewModel, isExpanded: $isCategoryExpanded, options: categoryOptions)
                }

            VStack(alignment: .leading, spacing: 8) {
                (Text(PostViewStrings.topic) + Text(PostViewStrings.requiredMark).foregroundStyle(Color.red60))
                    .pickpleTypography(.body01)

                PickpleTextField(
                    text: $postViewModel.topic,
                    type: .trailing,
                    placeholder: PostViewStrings.topicText,
                    trailingAccessory: .text("\(postViewModel.topic.count)/\(postViewModel.topicMaxLength)")
                )
                .onChange(of: postViewModel.topic) { _, newValue in
                    if newValue.count > postViewModel.topicMaxLength {
                        postViewModel.topic = String(newValue.prefix(postViewModel.topicMaxLength))
                    }
                }
            }
            
            // 수정 모드는 상품명/사진/가격/URL이 PATCH로 반영되지 않아(카테고리/제목(=주제)/설명만
            // 지원) 원래 값을 보여주기만 하고 편집을 막는다 — 순차 공개도 건너뛰고 한꺼번에 보여준다.
            ProductNameSectionView(postViewModel: postViewModel)

            ComparisonPhotoFieldBlock(photoA: $postViewModel.productA.photos, photoB: $postViewModel.productB.photos, isDisabled: postViewModel.isEditing)
                .revealed(postViewModel.isEditing || (isBasicInfoFilled && areNamesFilled))

            ProductPriceSectionView(postViewModel: postViewModel)
                .revealed(postViewModel.isEditing || (isBasicInfoFilled && areNamesFilled && arePhotosFilled))

            ProductURLSectionView(postViewModel: postViewModel)
                .revealed(postViewModel.isEditing || (isBasicInfoFilled && areNamesFilled && arePhotosFilled && arePricesFilled))

            DescriptionFieldBlock(text: $postViewModel.description, maxLength: postViewModel.descriptionMaxLength)
                .revealed(postViewModel.isEditing || (isBasicInfoFilled && areNamesFilled && arePhotosFilled && arePricesFilled && areUrlsFilled))
        }
        .animation(.easeInOut, value: isBasicInfoFilled)
        .animation(.easeInOut, value: areNamesFilled)
        .animation(.easeInOut, value: arePhotosFilled)
        .animation(.easeInOut, value: arePricesFilled)
        .animation(.easeInOut, value: areUrlsFilled)
    }
}

#Preview("빈 상태") {
    let viewModel = PostViewModel()
    viewModel.selectedType = .ab

    return ScrollView {
        ABWriteView(
            postViewModel: viewModel,
            isCategoryExpanded: .constant(false),
            categoryOptions: PostViewStrings.categoryOptions
        )
    }
}

#Preview("전부 채워짐") {
    let viewModel = PostViewModel()
    viewModel.selectedType = .ab
    viewModel.selectedCategory = "패션/잡화"
    viewModel.topic = "나이키 에어포스 흰색 vs 검정색, 뭐가 더 나을까?"
    viewModel.productA = PostProductDraft(
        photos: [UIImage(systemName: "photo")!],
        name: "나이키 에어포스 화이트",
        price: "129000",
        url: "https://example.com/a"
    )
    viewModel.productB = PostProductDraft(
        photos: [UIImage(systemName: "photo")!],
        name: "나이키 에어포스 블랙",
        price: "129000",
        url: "https://example.com/b"
    )
    viewModel.description = "둘 다 예뻐서 고민되는데 데일리로 신을 거라 관리 편한 쪽으로 고르고 싶어요."

    return ScrollView {
        ABWriteView(
            postViewModel: viewModel,
            isCategoryExpanded: .constant(false),
            categoryOptions: PostViewStrings.categoryOptions
        )
    }
}
