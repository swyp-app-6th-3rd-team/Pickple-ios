//
//  ABWriteView.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  A/B 픽 작성 순서: 카테고리·주제·상품A/B명(전부 필수, 처음부터 같이 보임) → 사진(필수,
//  한 섹션에 A/B 두 칸 나란히) → 가격(A/B) → URL(A/B) → 설명(선택). 각 단계는 그 앞
//  단계가 다 채워져야 나타난다.

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

            // 카테고리·주제와 함께 기본으로 보이는 상품A/B 이름.
            // 수정 모드는 상품명/사진/가격/URL이 PATCH로 반영되지 않아(카테고리/제목(=주제)/설명만
            // 지원) 원래 값을 보여주기만 하고 편집을 막는다 — 순차 공개도 건너뛰고 한꺼번에 보여준다.
            ProductNameFieldBlock(
                name: $postViewModel.productA.name,
                maxLength: postViewModel.productNameMaxLength,
                label: "\(PostViewStrings.abOptionALabel) \(PostViewStrings.productName)",
                isDisabled: postViewModel.isEditing
            )

            ProductNameFieldBlock(
                name: $postViewModel.productB.name,
                maxLength: postViewModel.productNameMaxLength,
                label: "\(PostViewStrings.abOptionBLabel) \(PostViewStrings.productName)",
                isDisabled: postViewModel.isEditing
            )

            ComparisonPhotoFieldBlock(photoA: $postViewModel.productA.photos, photoB: $postViewModel.productB.photos, isDisabled: postViewModel.isEditing)
                .revealed(postViewModel.isEditing || (isBasicInfoFilled && areNamesFilled))

            VStack(alignment: .leading, spacing: 20) {
                ProductPriceFieldBlock(
                    price: $postViewModel.productA.price,
                    label: "\(PostViewStrings.abOptionALabel) \(PostViewStrings.price)",
                    isDisabled: postViewModel.isEditing
                )
                ProductPriceFieldBlock(
                    price: $postViewModel.productB.price,
                    label: "\(PostViewStrings.abOptionBLabel) \(PostViewStrings.price)",
                    isDisabled: postViewModel.isEditing
                )
            }
            .revealed(postViewModel.isEditing || (isBasicInfoFilled && areNamesFilled && arePhotosFilled))

            VStack(alignment: .leading, spacing: 20) {
                ProductURLFieldBlock(
                    url: $postViewModel.productA.url,
                    label: "\(PostViewStrings.abOptionALabel) \(PostViewStrings.url)",
                    isDisabled: postViewModel.isEditing
                )
                ProductURLFieldBlock(
                    url: $postViewModel.productB.url,
                    label: "\(PostViewStrings.abOptionBLabel) \(PostViewStrings.url)",
                    isDisabled: postViewModel.isEditing
                )
            }
            .revealed(postViewModel.isEditing || (isBasicInfoFilled && areNamesFilled && arePhotosFilled && arePricesFilled))

            DescriptionFieldBlock(text: $postViewModel.description, maxLength: postViewModel.descriptionMaxLength)
                .revealed(postViewModel.isEditing || (isBasicInfoFilled && areNamesFilled && arePhotosFilled && arePricesFilled && areUrlsFilled))
        }
        .padding(.horizontal, 20)
        .animation(.easeInOut, value: isBasicInfoFilled)
        .animation(.easeInOut, value: areNamesFilled)
        .animation(.easeInOut, value: arePhotosFilled)
        .animation(.easeInOut, value: arePricesFilled)
        .animation(.easeInOut, value: areUrlsFilled)
    }
}

#Preview {
    let viewModel = PostViewModel()
    viewModel.selectedType = .ab

    return ScrollView {
        ABWriteView(
            postViewModel: viewModel,
            isCategoryExpanded: .constant(false),
            categoryOptions: PostViewStrings.categoryOptions
        )
        .padding(.top, 32)
    }
}
