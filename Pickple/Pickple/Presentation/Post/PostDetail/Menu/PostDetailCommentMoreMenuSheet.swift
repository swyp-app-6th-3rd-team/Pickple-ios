//
//  PostDetailCommentMoreMenuSheet.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

// 댓글 더보기(⋮) 바텀시트. 내 댓글이면 수정/삭제, 남의 댓글이면 신고/차단을 보여준다.
// 신고/차단은 게시글 쪽과 달리 별도 확인 모달 없이 탭하면 바로 시트가 닫힌다.
struct PostDetailCommentMoreMenuSheet: View {
    let isMine: Bool
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onReport: () -> Void
    let onBlock: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            if isMine {
                PostDetailMenuRow(icon: "PickpleModify", title: "수정하기", tint: Color.neutral100, action: onEdit)
                PostDetailMenuRow(icon: "PickpleDelete", title: "삭제하기", tint: Color.red60, action: onDelete)
            } else {
                PostDetailMenuRow(icon: "PickpleAlert", title: "신고하기", tint: Color.red60, action: onReport)
                PostDetailMenuRow(icon: "PickpleBlock", title: "차단하기", tint: Color.neutral100, action: onBlock)
            }
        }
        .padding(20)
        .presentationDetents([.height(273)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            PostDetailCommentMoreMenuSheet(isMine: true, onEdit: {}, onDelete: {}, onReport: {}, onBlock: {})
        }
}
