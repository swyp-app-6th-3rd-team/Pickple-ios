//
//  PostDetailMoreMenuSheet.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

// 게시글 더보기(⋮) 바텀시트. 내 글이면 수정/삭제, 남의 글이면 신고/차단을 보여준다.
struct PostDetailMoreMenuSheet: View {
    let isMine: Bool
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onReport: () -> Void
    let onBlock: () -> Void
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            if isMine {
                PostDetailMenuRow(icon: "PickpleModify", title: "수정하기", tint: Color.neutral100, action: onEdit)
                PostDetailMenuRow(icon: "PickpleDelete", title: "삭제하기", tint: Color.red60, action: onDelete)
            } else {
                PostDetailMenuRow(icon: "PickpleAlert", title: "신고하기", tint: Color.red60, action: onReport)
                PostDetailMenuRow(icon: "PickpleBlock", title: "차단하기", tint: Color.neutral100, action: onBlock)
            }

            Button(action: onClose) {
                Text("닫기")
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.neutral70)
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .background(Color.neutral5)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(.top, 12)
        }
        .padding(20)
        .presentationDetents([.height(273)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            PostDetailMoreMenuSheet(isMine: true, onEdit: {}, onDelete: {}, onReport: {}, onBlock: {}, onClose: {})
        }
}
