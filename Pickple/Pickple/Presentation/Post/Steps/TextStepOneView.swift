//
//  TextStepOneView.swift
//  Pickple
//
//  Created by 박윤수 on 8/29/26.
//

import SwiftUI

// 텍스트 게시글 1단계: 카테고리 선택. 2단계는 이후 이 파일에 추가된다.
// 지금은 ForAgainstStepOneView와 내용이 같지만, 각 유형이 단계를 더 갖게 되면 갈라질 예정이라 미리 분리해둔다.
struct TextStepOneView: View {
    @ObservedObject var postViewModel: PostViewModel
    @Binding var isCategoryExpanded: Bool
    let categoryOptions: [String]

    var body: some View {
        CategoryFieldBlock(postViewModel: postViewModel, isExpanded: .constant(false), options: categoryOptions)
            .floatingOverSiblings {
                CategoryFieldBlock(postViewModel: postViewModel, isExpanded: $isCategoryExpanded, options: categoryOptions)
            }
    }
}
