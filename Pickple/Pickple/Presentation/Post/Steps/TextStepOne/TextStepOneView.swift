//
//  TextStepOneView.swift
//  Pickple
//
//  Created by 박윤수 on 8/29/26.
//
// 1차 점검 완료 - 9월 12일

import SwiftUI

// 일반 게시글: 카테고리 + 제목 + 설명. 진행 바 없이 한 화면에서 바로 게시한다.
struct TextStepOneView: View {
    @Bindable var postViewModel: PostViewModel
    @Binding var isCategoryExpanded: Bool
    let categoryOptions: [String]

    @FocusState private var isTitleFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // CategoryFieldBlock의 floatingOverSiblings가 쓰는 zIndex는 같은 부모(VStack) 안의
            // 형제끼리만 적용된다 — 안내문구와 묶어서 한 단계 더 감싸면(중첩 VStack) 드롭다운이
            // 이 바깥 VStack의 다른 형제(제목/설명)보다 위에 그려지지 않는다. 그래서 안내문구도
            // 이 레벨의 직접 형제로 둔다.
            Text(PostViewStrings.textStepOneTitle)
                .pickpleTypography(.heading02)
                .padding(.bottom, 12)

            CategoryFieldBlock(postViewModel: postViewModel, isExpanded: .constant(false), options: categoryOptions)
                .floatingOverSiblings {
                    CategoryFieldBlock(postViewModel: postViewModel, isExpanded: $isCategoryExpanded, options: categoryOptions)
                }

            VStack(alignment: .leading, spacing: 8) {
                (Text(PostViewStrings.title) + Text(PostViewStrings.requiredMark).foregroundStyle(Color.red60))
                    .pickpleTypography(.body01_500)

                PickpleTextField(
                    text: $postViewModel.title,
                    placeholder: PostViewStrings.titlePlaceholder,
                    trailingAccessory: .text("\(postViewModel.title.count)/\(postViewModel.titleMaxLength)"),
                    state: isTitleFocused ? .ing : ._default
                )
                .focused($isTitleFocused)
                .onChange(of: postViewModel.title) { _, newValue in
                    if newValue.count > postViewModel.titleMaxLength {
                        postViewModel.title = String(newValue.prefix(postViewModel.titleMaxLength))
                    }
                }
            }

            DescriptionFieldBlock(text: $postViewModel.description, maxLength: postViewModel.descriptionMaxLength)
        }
    }
}

#Preview {
    let viewModel = PostViewModel()
    viewModel.selectedType = .text

    return ScrollView {
        TextStepOneView(
            postViewModel: viewModel,
            isCategoryExpanded: .constant(false),
            categoryOptions: PostViewStrings.categoryOptions
        )
    }
}
