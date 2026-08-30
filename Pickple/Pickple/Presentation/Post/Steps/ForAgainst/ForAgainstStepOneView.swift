//
//  ForAgainstStepOneView.swift
//  Pickple
//
//  Created by 박윤수 on 8/29/26.
//

import SwiftUI

// 찬반 픽 1단계: 카테고리 선택. 2단계/3단계는 이후 이 파일에 추가된다.
struct ForAgainstStepOneView: View {
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
