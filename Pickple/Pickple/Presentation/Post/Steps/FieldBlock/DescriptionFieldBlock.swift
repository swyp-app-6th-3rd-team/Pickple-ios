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
            
            ZStack(alignment: .top) {
                TextEditor(text: $text)
                    .pickpleTypography(.body01_400)
                    .foregroundStyle(Color.neutral100)
                    .scrollContentBackground(.hidden)
                    .frame(maxWidth: .infinity, minHeight: 180)
                    .focused($isFocused)
                    .padding(.horizontal, 10)
                    .padding(.top, 7)
                    .onChange(of: text) { _, newValue in
                        if newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Text("\(text.count)/\(maxLength)")
                            .pickpleTypography(.body02_400)
                            .foregroundStyle(Color.neutral40)
                            .padding(.trailing, 20)
                            .padding(.bottom, 15)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isFocused ? PickpleTextFieldStateType.ing.borderColor : Color.navy10, lineWidth: 1)
                    }
                
                if text.isEmpty {
                    Text(PostViewStrings.descriptionPlaceholder)
                        .pickpleTypography(.body01_400)
                        .foregroundStyle(Color.neutral40)
                        .allowsHitTesting(false)
                        .padding(.top, 15)

                }
            }
        }
    }
}

#Preview {
    DescriptionFieldBlock(text: .constant(""), maxLength: 300)
}
