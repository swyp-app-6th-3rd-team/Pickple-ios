//
//  CommunityCategoryRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료 - 9월 12일

import SwiftUI

struct CommunityCategoryRow: View {
    @Binding var selectedCategory: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(CommunityViewModel.categories, id: \.self) { category in
                    let isSelected = category == selectedCategory
                    
                    Button(action: { selectedCategory = category }) {
                        Text(category)
                            .pickpleTypography(.body01)
                            .foregroundStyle(isSelected ? Color.white : Color.neutral50)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(isSelected ? Color.black : Color.navy10)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }

        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedCategory = CommunityViewModel.categories[0]

        var body: some View {
            CommunityCategoryRow(selectedCategory: $selectedCategory)
        }
    }
    return PreviewWrapper()
}
