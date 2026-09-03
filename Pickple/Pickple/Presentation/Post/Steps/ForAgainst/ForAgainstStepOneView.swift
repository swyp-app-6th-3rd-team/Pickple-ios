//
//  ForAgainstStepOneView.swift
//  Pickple
//
//  Created by 박윤수 on 8/29/26.
//

import SwiftUI

// 찬반 픽 1단계: 카테고리 선택 + 설명 입력.
struct ForAgainstStepOneView: View {
    @ObservedObject var postViewModel: PostViewModel
    @Binding var isCategoryExpanded: Bool
    let categoryOptions: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(PostViewStrings.forAgainstStepOneTitle)
                .pickpleTypography(.heading02)

            CategoryFieldBlock(postViewModel: postViewModel, isExpanded: .constant(false), options: categoryOptions)
                .floatingOverSiblings {
                    CategoryFieldBlock(postViewModel: postViewModel, isExpanded: $isCategoryExpanded, options: categoryOptions)
                }

            DescriptionFieldBlock(text: $postViewModel.description, maxLength: postViewModel.descriptionMaxLength)
        }
    }
}
