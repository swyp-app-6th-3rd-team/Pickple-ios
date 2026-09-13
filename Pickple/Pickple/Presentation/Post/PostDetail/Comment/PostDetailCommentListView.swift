//
//  PostDetailCommentListView.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
// 1차 점검 완료 - 9월 12일
// 로그인 안내 문구 폰트 미지정


import SwiftUI

struct PostDetailCommentListView: View {
    @Bindable var postDetailViewModel: PostDetailViewModel
    let onPickTapped: (Comment) -> Void
    let onCommentMoreTapped: (Comment) -> Void
    let onLoginRequired: () -> Void
    
    var body: some View {
        // 게스트는 댓글 목록 조회 자체가 인증을 요구해서 항상 comments == []다 — isLoggedIn을
        // 먼저 체크해야, 게스트가 "댓글 없음" 빈 화면이 아니라 블러+로그인 화면을 본다.
        if !postDetailViewModel.isLoggedIn {
            // 게스트는 실제 댓글을 절대 못 받아오므로(항상 []), 블러 뒤에 보여줄 내용이 없다.
            // 실제 목록처럼 보이도록 자리만 차지하는 가짜 댓글을 대신 그린다.
            placeholderCommentRows
                .blur(radius: 15)
                .disabled(true)
                .overlay {
                    VStack(spacing: 16) {
                        Text(PostDetailStrings.commentViewRequiredDescription)
                            .pickpleTypography(.body02) //폰트 미지정
                            .foregroundStyle(Color.neutral70)

                        Button(action: onLoginRequired) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(Color.white)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.black)
                                    }
                                    .frame(width: 113, height: 48)
                                Text("로그인하기")
                                    .pickpleTypography(.body01)
                                    .foregroundStyle(Color.black)
                            }
                        }
                    }
                }
        } else if postDetailViewModel.comments.isEmpty {
            PostDetailCommentEmptyView()
        } else {
            commentRows
        }
    }
    
    private var commentRows: some View {
        VStack(alignment: .leading, spacing: 0) {
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
                .padding(.vertical, 20)
                
                Divider()
            }
        }
    }

    // 실제 데이터가 아니라 블러 뒤에 깔 모양만 필요해서, id는 음수로 둬서 실제 댓글 id와
    // 절대 겹치지 않게 한다. 어차피 .disabled(true)와 overlay 버튼에 가려져 탭도 안 된다.
    private var placeholderComments: [Comment] {
        [
            Comment(id: -1, authorNickname: "픽플고인물", authorLevel: 5, authorProfileImageUrl: nil, content: "이거 너무 좋아요 제가 뭐뭐 써봤는데 좋습니다", createdAt: Date(), pickCount: 3, mine: false),
            Comment(id: -2, authorNickname: "픽플고인물", authorLevel: 1, authorProfileImageUrl: nil, content: "이거 너무 좋아요 제가 뭐뭐 써봤는데 좋습니다", createdAt: Date(), pickCount: 3, mine: false),
            Comment(id: -3, authorNickname: "픽플고인물", authorLevel: 2, authorProfileImageUrl: nil, content: "이거 너무 좋아요 제가 뭐뭐 써봤는데 좋습니다", createdAt: Date(), pickCount: 3, mine: false)
        ]
    }

    private var placeholderCommentRows: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(placeholderComments) { comment in
                PostDetailCommentRow(
                    comment: comment,
                    isPicked: false,
                    canPick: false,
                    onMoreTapped: {},
                    onPickTapped: {}
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
