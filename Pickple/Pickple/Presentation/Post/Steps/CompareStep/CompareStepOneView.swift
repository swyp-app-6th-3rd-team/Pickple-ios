//
//  CompareStepOneView.swift
//  Pickple
//
//  Created by 박윤수 on 8/29/26.
//

import SwiftUI

// 비교 픽 1단계: 카테고리 선택 + 비교 주제 입력. 2단계/3단계는 이후 이 파일에 추가된다.
struct CompareStepOneView: View {
    @ObservedObject var postViewModel: PostViewModel
    @Binding var isCategoryExpanded: Bool
    let categoryOptions: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(PostViewStrings.compareStepOneTitle)
                .pickpleTypography(.heading02)
                .padding(.horizontal, 24)

            CategoryFieldBlock(postViewModel: postViewModel, isExpanded: .constant(false), options: categoryOptions)
                .floatingOverSiblings {
                    CategoryFieldBlock(postViewModel: postViewModel, isExpanded: $isCategoryExpanded, options: categoryOptions)
                }

            VStack(alignment: .leading, spacing: 8) {
                (Text(PostViewStrings.topic) + Text(PostViewStrings.requiredMark).foregroundStyle(Color.red60))
                    .pickpleTypography(.body01)
                    .padding(.horizontal, 24)

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
                .padding(.horizontal, 20)
            }

            DescriptionFieldBlock(text: $postViewModel.description, maxLength: postViewModel.descriptionMaxLength)
        }
    }
}
