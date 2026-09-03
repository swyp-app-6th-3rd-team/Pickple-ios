//
//  DescriptionFieldBlock.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 박스 높이/여백은 임시값

import SwiftUI

// 글 작성 1단계에서 공통으로 쓰는 "설명" 라벨 + 여러 줄 입력 박스 + 글자 수 카운터.
struct DescriptionFieldBlock: View {
    @Binding var text: String
    let maxLength: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            (Text(PostViewStrings.description) + Text(PostViewStrings.requiredMark).foregroundStyle(Color.red60))
                .pickpleTypography(.body01)
            
            ZStack(alignment: .bottomTrailing) {
                if text.isEmpty {
                        Text(PostViewStrings.descriptionPlaceholder)
                            .pickpleTypography(.body01)
                            .foregroundStyle(Color.neutral40)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                }
                
                TextEditor(text: $text)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.neutral100)
                    .scrollContentBackground(.hidden)
                    .frame(height: 160)
                    .onChange(of: text) { _, newValue in
                        if newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                    }
                
                HStack {
                    Spacer()
                    Text("\(text.count)/\(maxLength)")
                        .pickpleTypography(.body02)
                        .foregroundStyle(Color.neutral40)
                }
                
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.navy10, lineWidth: 1)
            }
            
        }
    }
}

#Preview {
    DescriptionFieldBlock(text: .constant(""), maxLength: 300)
        .padding()
}
