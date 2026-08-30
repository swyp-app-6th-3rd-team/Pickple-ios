//
//  CategoryFieldBlock.swift
//  Pickple
//
//  Created by 박윤수 on 8/29/26.
//

import SwiftUI

// 글 유형(찬반/비교/텍스트) 1단계에서 공통으로 쓰는 카테고리 라벨 + 드롭다운 묶음.
struct CategoryFieldBlock: View {
    @ObservedObject var postViewModel: PostViewModel
    @Binding var isExpanded: Bool
    let options: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            (Text(PostViewStrings.category) + Text(PostViewStrings.requiredMark).foregroundStyle(Color.red60))
                .pickpleTypography(.body01)
                .padding(.horizontal, 24)

            PickpleDropdownView(isExpanded: $isExpanded, selectedValue: $postViewModel.selectedCategory, options: options)
        }
    }
}
