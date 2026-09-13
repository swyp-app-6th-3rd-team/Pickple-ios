//
//  PostDetailCommentInputBar.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
// 1차 점검 완료 - 9월 13일

import SwiftUI

struct PostDetailCommentInputBar: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    let onSubmit: () -> Void

    var body: some View {
        ZStack {
            ZStack(alignment: .trailing) {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color.clear)
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.navy10)
                            .frame(maxWidth: .infinity, minHeight: 56)
                        
                    )
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                
                Button(action: onSubmit) {
                    Text(PostDetailStrings.commentSubmit)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 8)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(.trailing, 31)
            }
            
            HStack{
                TextField(PostDetailStrings.commentPlaceholder, text: $text)
                    .focused(isFocused)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.neutral40)
                    .padding(.horizontal, 20)
                    .padding(.vertical,15)

                
            }
            .padding(.leading, 21)
            .padding(.trailing, 11)
            .padding(.vertical, 15)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var text = ""
        @FocusState private var isFocused: Bool

        var body: some View {
            PostDetailCommentInputBar(text: $text, isFocused: $isFocused) {}
        }
    }
    return PreviewWrapper()
}
