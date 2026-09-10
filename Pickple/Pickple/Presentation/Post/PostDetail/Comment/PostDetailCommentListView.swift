//
//  PostDetailCommentListView.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//

import SwiftUI

struct PostDetailCommentListView: View {
    @Bindable var postDetailViewModel: PostDetailViewModel
    let onPickTapped: (Comment) -> Void
    let onCommentMoreTapped: (Comment) -> Void
    let onLoginRequired: () -> Void
    
    var body: some View {
        if postDetailViewModel.comments.isEmpty {
            PostDetailCommentEmptyView()
        } else if postDetailViewModel.isLoggedIn {
            commentRows
        } else {
            commentRows
                .blur(radius: 6) // TODO: 디자인 확정 필요 - 임시 블러 값
                .disabled(true)
                .overlay {
                    Button(action: onLoginRequired) {
                        VStack(spacing: 20) {
                            
                            Text(PostDetailStrings.commentViewRequiredDescription)
                                .pickpleTypography(.body02)
                                .foregroundStyle(Color.neutral70)
                            
                            Button(action: {}) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(Color.white)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 8)
                                            
                                                .stroke(Color.neutral100)
                                        }
                                        .frame(width: 113, height: 48)
                                    Text("로그인하기")
                                        .pickpleTypography(.body01)
                                        .foregroundStyle(Color.neutral100)
                                }
                            }
                            
                        }
                        .padding(20)
                        
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
        }
    }
    
    private var commentRows: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(postDetailViewModel.sortedComments) { comment in
                PostDetailCommentRow(
                    comment: comment,
                    isPicked: postDetailViewModel.isPicked(comment.id),
                    // 본인 댓글은 원픽 대상이 아니다(API_SPEC.md: 자기 댓글이면 400) — 서버가
                    // 거부하기 전에 클라이언트에서부터 막는다.
                    canPick: postDetailViewModel.canPickAnyComment && !comment.mine,
                    onMoreTapped: { onCommentMoreTapped(comment) },
                    onPickTapped: { onPickTapped(comment) }
                )
            }
        }
    }
}

#Preview("로그인") {
    let viewModel = PostDetailViewModel(voteType: .ab, isLoggedIn: true)
    PostDetailCommentListView(
        postDetailViewModel: viewModel,
        onPickTapped: { _ in },
        onCommentMoreTapped: { _ in },
        onLoginRequired: {}
    )
    .padding()
    .task { await viewModel.loadComments() }
}

#Preview("게스트") {
    let viewModel = PostDetailViewModel(voteType: .ab, isLoggedIn: false)
    PostDetailCommentListView(
        postDetailViewModel: viewModel,
        onPickTapped: { _ in },
        onCommentMoreTapped: { _ in },
        onLoginRequired: {}
    )
    .padding()
    .task { await viewModel.loadComments() }
}
