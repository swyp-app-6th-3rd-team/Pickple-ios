//
//  DescriptionFieldBlock.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  1차 점검 완료 - 9월 12일
// 작성되는 텍스트의 폰트와 색 확인 필요

import SwiftUI

// 글 작성 1단계에서 공통으로 쓰는 "설명" 라벨 + 여러 줄 입력 박스 + 글자 수 카운터.
struct DescriptionFieldBlock: View {
    @Binding var text: String
    let maxLength: Int

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(PostViewStrings.description)
                .pickpleTypography(.body01_500)
            
            TextEditor(text: $text)
                .pickpleTypography(.body01_500)
                .foregroundStyle(Color.neutral100)
                .scrollContentBackground(.hidden)
                .frame(maxWidth: .infinity, minHeight: 180)
                .focused($isFocused)
                .onChange(of: text) { _, newValue in
                    if newValue.count > maxLength {
                        text = String(newValue.prefix(maxLength))
                    }
                }
                .overlay(alignment: .top) {
                    if text.isEmpty {
                        Text(PostViewStrings.descriptionPlaceholder)
                            .pickpleTypography(.body01_500)
                            .foregroundStyle(Color.neutral40)
                            .allowsHitTesting(false)
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    Text("\(text.count)/\(maxLength)")
                        .pickpleTypography(.body02_600)
                        .foregroundStyle(Color.neutral40)
                }
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isFocused ? PickpleTextFieldStateType.ing.borderColor : Color.navy10, lineWidth: 1)
            }
            
        }
    }
}

#Preview {
    DescriptionFieldBlock(text: .constant(""), maxLength: 300)
        .padding()
}
