//
//  PostWriteFlowStepContent.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//
//  유형/단계에 맞는 입력 화면을 고른다.

import SwiftUI

struct PostWriteFlowStepContent: View {
    @ObservedObject var postViewModel: PostViewModel
    @Binding var isCategoryExpanded: Bool
    let categoryOptions: [String]

    var body: some View {
        switch postViewModel.selectedType {
        case .forAgainst:
            if postViewModel.currentIndex == 0 {
                ForAgainstStepOneView(postViewModel: postViewModel, isCategoryExpanded: $isCategoryExpanded, categoryOptions: categoryOptions)
                    .padding(.horizontal, 20)
            } else {
                ForAgainstStepTwoView(postViewModel: postViewModel)
            }
        case .ab:
            if postViewModel.currentIndex == 0 {
                ABStepOneView(postViewModel: postViewModel, isCategoryExpanded: $isCategoryExpanded, categoryOptions: categoryOptions)
            } else if postViewModel.currentIndex == 1 {
                ABStepTwoView(postViewModel: postViewModel)
            } else {
                ABStepThreeView(postViewModel: postViewModel)
            }
        case .text:
            TextStepOneView(postViewModel: postViewModel, isCategoryExpanded: $isCategoryExpanded, categoryOptions: categoryOptions)
        }
    }
}
