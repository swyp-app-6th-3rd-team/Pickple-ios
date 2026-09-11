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
    @Bindable var postDetailViewModel: PostDetailViewModel
    let onMoreTapped: () -> Void
    let onVote: (PostDetailVoteSide) -> Void
    let onPickTapped: (Comment) -> Void
    let onCommentMoreTapped: (Comment) -> Void
    let onLoginRequired: () -> Void
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
                    .padding(.horizontal, 20)
                    .padding(.top, 16)


                PostDetailProductVoteSection(post: post, postDetailViewModel: postDetailViewModel, onVote: onVote)
                    .padding(.horizontal, 20)


                Rectangle()
                    .frame(height: 8)
                    .foregroundStyle(Color.neutral5)

                PostDetailCommentSectionHeader(
                    count: postDetailViewModel.comments.count,
                    sortOption: $postDetailViewModel.sortOption,
                    isSortExpanded: $isSortExpanded
                )
                .padding(.horizontal, 20)


                PostDetailCommentListView(
                    postDetailViewModel: postDetailViewModel,
                    onPickTapped: onPickTapped,
                    onCommentMoreTapped: onCommentMoreTapped,
                    onLoginRequired: onLoginRequired
                )
                .padding(.horizontal, 20)

            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var isSortExpanded = false

        var body: some View {
            ScrollView {
                PostDetailContent(
                    post: PostDetail(
                        id: 1,
                        type: .ab,
                        category: "패션/잡화",
                        title: "이거 흰색? 검은색?",
                        description: "데일리로 신을건데 어떤 색이 더 무난할까요?",
                        createdAt: Date(),
                        commentCount: 2,
                        authorId: 1,
                        authorNickname: "닉네임",
                        authorProfileImageUrl: nil,
                        authorGradeLevel: 5,
                        authorGradeName: "LV.5",
                        authorRanking: nil,
                        isMine: true,
                        vote: PostDetailVote(
                            voted: false,
                            selectedOptionId: nil,
                            voterCount: 3,
                            products: [
                                PostDetailProduct(id: 1, name: "나이키 에어포스 흰색", price: 135_000, purchaseURL: "11pcs.11st.co.kr/...", imageUrl: nil, displayOrder: 1),
                                PostDetailProduct(id: 2, name: "나이키 에어포스 검은색", price: 135_000, purchaseURL: "11pcs.11st.co.kr/...", imageUrl: nil, displayOrder: 2)
                            ],
                            options: [
                                PostDetailVoteOption(optionId: 1, label: nil, productId: 1, displayOrder: 1, voteCount: nil, percentage: nil),
                                PostDetailVoteOption(optionId: 2, label: nil, productId: 2, displayOrder: 2, voteCount: nil, percentage: nil)
                            ]
                        )
                    ),
                    postDetailViewModel: PostDetailViewModel(voteType: .ab),
                    onMoreTapped: {},
                    onVote: { _ in },
                    onPickTapped: { _ in },
                    onCommentMoreTapped: { _ in },
                    onLoginRequired: {},
                    isSortExpanded: $isSortExpanded
                )
            }
        }
    }
    return PreviewWrapper()
}
