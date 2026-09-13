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
    var isEditingComment: Bool
    let onSubmit: () -> Void
    

    var body: some View {
        if !isEditingComment {
            HStack {
                TextField(
                    "",
                    text: $text,
                    prompt: Text(PostDetailStrings.commentPlaceholder)
                        .foregroundStyle(Color.neutral40),
                    axis: .vertical
                )
                .focused(isFocused)
                .pickpleTypography(.body01)
                .foregroundStyle(Color.neutral100)
                .padding(.leading, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color.neutral5)
                )
                
                
                Spacer()
                
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(Color.yellow60)
                    
                    
                    Image("PickpleSubmit")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.navy60)
                }
                .onTapGesture(perform: onSubmit)
            }

        } else {
            VStack(alignment:.leading, spacing: 8) {
                HStack(spacing: 4) {
                    Image("PickpleEditComment")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color.neutral40)
                    
                    Text("댓글 수정 중...")
                        .pickpleTypography(.body02)
                        .foregroundStyle(Color.neutral40)
                }
                .padding(.leading, 4)
            HStack {
                TextField(
                    "",
                    text: $text,
                    prompt: Text(PostDetailStrings.commentPlaceholder)
                        .foregroundStyle(Color.neutral40),
                    axis: .vertical
                )
                .focused(isFocused)
                .pickpleTypography(.body01)
                .foregroundStyle(Color.neutral100)
                .padding(.leading, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color.neutral5)
                )
                
                
                Spacer()
                
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(Color.yellow60)
                    
                    
                    Image("PickpleSubmit")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.navy60)
                }
                .onTapGesture(perform: onSubmit)
            }
        }
        }

    }
}

#Preview("작성 중") {
    struct PreviewWrapper: View {
        @State private var text = ""
        @FocusState private var isFocused: Bool

        var body: some View {
            PostDetailCommentInputBar(text: $text, isFocused: $isFocused, isEditingComment: false) {}
        }
    }
    return PreviewWrapper()
}

#Preview("수정 중") {
    struct PreviewWrapper: View {
        @State private var text = "수정할 댓글 내용"
        @FocusState private var isFocused: Bool

        var body: some View {
            PostDetailCommentInputBar(text: $text, isFocused: $isFocused, isEditingComment: true) {}
        }
    }
    return PreviewWrapper()
}
