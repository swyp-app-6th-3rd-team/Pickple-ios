//
//  PostWriteFlowStepContent.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//
//  유형에 맞는 작성 화면을 고른다. 예전엔 유형별로 여러 단계를 오갔지만,
//  지금은 유형당 화면 하나에 모든 입력을 합쳐서 보여준다.

import SwiftUI

struct PostWriteFlowStepContent: View {
    let postViewModel: PostViewModel
    @Binding var isCategoryExpanded: Bool
    let categoryOptions: [String]

    var body: some View {
        switch postViewModel.selectedType {
        case .forAgainst:
            ForAgainstWriteView(postViewModel: postViewModel, isCategoryExpanded: $isCategoryExpanded, categoryOptions: categoryOptions)
        case .ab:
            ABWriteView(postViewModel: postViewModel, isCategoryExpanded: $isCategoryExpanded, categoryOptions: categoryOptions)
        case .text:
            TextStepOneView(postViewModel: postViewModel, isCategoryExpanded: $isCategoryExpanded, categoryOptions: categoryOptions)
        }
    }
}
