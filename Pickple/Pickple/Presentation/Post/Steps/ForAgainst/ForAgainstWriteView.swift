//
//  ForAgainstWriteView.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
// 1차 점검 완료 - 9월 12일

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
        VStack(alignment: .leading, spacing: 32) {
            Text(PostViewStrings.forAgainstStepOneTitle)
                .pickpleTypography(.heading02)
                .foregroundStyle(Color.black)
            
            
            ForAgainstPostFieldSectionView(
                postViewModel: postViewModel,
                isCategoryExpanded: $isCategoryExpanded,
                categoryOptions: categoryOptions
            )
        }
    }
}

#Preview("빈 상태") {
    ScrollView {
        ForAgainstWriteView(
            postViewModel: PostViewModel(),
            isCategoryExpanded: .constant(false),
            categoryOptions: PostViewStrings.categoryOptions
        )
    }
}

#Preview("전부 채워짐") {
    let viewModel = PostViewModel()
    viewModel.selectedType = .forAgainst
    viewModel.selectedCategory = "패션/잡화"
    viewModel.product = PostProductDraft(
        photos: [UIImage(systemName: "photo")!],
        name: "나이키 에어포스 화이트",
        price: "129000",
        url: "https://example.com/product"
    )
    viewModel.description = "데일리로 신을 건데 흰색이 때 잘 타려나 고민돼요."

    return ScrollView {
        ForAgainstWriteView(
            postViewModel: viewModel,
            isCategoryExpanded: .constant(false),
            categoryOptions: PostViewStrings.categoryOptions
        )
    }
}
