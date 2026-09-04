//
//  PostDetailContent.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//
//  캐러셀/헤더/본문/투표/댓글까지 스크롤되는 본문 전체.

import SwiftUI

struct PostDetailContent: View {
    let post: PostDetail
    @ObservedObject var postDetailViewModel: PostDetailViewModel
    let onMoreTapped: () -> Void
    let onVote: (PostDetailVoteSide) -> Void
    let onPickTapped: (Comment) -> Void
    let onCommentMoreTapped: (Comment) -> Void
    @Binding var isSortExpanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if post.type != .text {
                PostDetailImageCarousel(
                    images: post.images,
                    participantCount: post.participantCount,
                    currentIndex: $postDetailViewModel.currentImageIndex
                )
                // 캐러셀 자체의 프레임 아래쪽 끝 y좌표를 부모(PostDetailView)로 흘려보낸다.
                // 이 지점이 GNB 높이 아래로 올라가면 이미지를 다 지나쳤다는 뜻.
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .preference(
                                key: CarouselBottomKey.self,
                                value: geo.frame(in: .named("postDetailScroll")).maxY
                            )
                    }
                )
            }

            VStack(spacing: 16) {
                PostDetailHeaderSection(post: post, onMoreTapped: onMoreTapped)

                PostDetailProductVoteSection(post: post, postDetailViewModel: postDetailViewModel, onVote: onVote)

                Rectangle()
                    .frame(height: 8)
                    .foregroundStyle(Color.neutral5)

                PostDetailCommentSectionHeader(
                    count: postDetailViewModel.comments.count,
                    sortOption: $postDetailViewModel.sortOption,
                    isSortExpanded: $isSortExpanded
                )

                if postDetailViewModel.comments.isEmpty {
                    PostDetailCommentEmptyView()
                } else {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(postDetailViewModel.sortedComments) { comment in
                            PostDetailCommentRow(
                                comment: comment,
                                isPicked: postDetailViewModel.isPicked(comment.id),
                                canPick: postDetailViewModel.canPickAnyComment,
                                onMoreTapped: { onCommentMoreTapped(comment) },
                                onPickTapped: { onPickTapped(comment) }
                            )
                        }
                    }
                }
            }
            .padding(20)
        }
    }
}
