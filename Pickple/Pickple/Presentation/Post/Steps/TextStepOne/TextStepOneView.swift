//
//  TextStepOneView.swift
//  Pickple
//
//  Created by 박윤수 on 8/29/26.
//

import SwiftUI

// 일반 게시글: 카테고리 + 제목 + 설명. 진행 바 없이 한 화면에서 바로 게시한다.
struct TextStepOneView: View {
    @ObservedObject var postViewModel: PostViewModel
    @Binding var isCategoryExpanded: Bool
    let categoryOptions: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(PostViewStrings.textStepOneTitle)
                .pickpleTypography(.heading02)
                .padding(.horizontal, 24)

            CategoryFieldBlock(postViewModel: postViewModel, isExpanded: .constant(false), options: categoryOptions)
                .floatingOverSiblings {
                    CategoryFieldBlock(postViewModel: postViewModel, isExpanded: $isCategoryExpanded, options: categoryOptions)
                }

            VStack(alignment: .leading, spacing: 8) {
                (Text(PostViewStrings.title) + Text(PostViewStrings.requiredMark).foregroundStyle(Color.red60))
                    .pickpleTypography(.body01)
                    .padding(.horizontal, 24)

                PickpleTextField(
                    text: $postViewModel.title,
                    type: .trailing,
                    placeholder: PostViewStrings.titlePlaceholder,
                    trailingAccessory: .text("\(postViewModel.title.count)/\(postViewModel.titleMaxLength)")
                )
                .onChange(of: postViewModel.title) { _, newValue in
                    if newValue.count > postViewModel.titleMaxLength {
                        postViewModel.title = String(newValue.prefix(postViewModel.titleMaxLength))
                    }
                }
                .padding(.horizontal, 20)
            }

            DescriptionFieldBlock(text: $postViewModel.description, maxLength: postViewModel.descriptionMaxLength)
        }
    }
}
