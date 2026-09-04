//
//  PostDetailCommentInputBar.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

struct PostDetailCommentInputBar: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    let onSubmit: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            TextField(PostDetailStrings.commentPlaceholder, text: $text)
                .focused(isFocused)
                .pickpleTypography(.body02)
                .padding(.horizontal, 16)
                .frame(height: 44)
                .background(Color.neutral5)
                .clipShape(Capsule())

            Button(action: onSubmit) {
                Text(PostDetailStrings.commentSubmit)
                    .pickpleTypography(.body02)
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 16)
                    .frame(height: 44)
                    .background(Color.black)
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
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
