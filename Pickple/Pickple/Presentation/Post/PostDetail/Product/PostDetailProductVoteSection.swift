//
//  PostDetailProductVoteSection.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료 - 9월 12일

import SwiftUI

// A/B 탭 선택 + 상품 정보 + 투표 버튼까지, 게시글 상세의 상품/투표 블록.
// 일반 게시글에서는 상품 정보가 없어서 비어 보인다(호출부에서 firstProduct 존재 여부로 감싸는 걸 권장).
struct PostDetailProductVoteSection: View {
    let post: PostDetail
    @Bindable var postDetailViewModel: PostDetailViewModel
    let onVote: (PostDetailVoteSide) -> Void

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 20) {
                if post.type == .ab {
                    PostDetailProductTabPicker(
                        firstLabel: postDetailViewModel.firstLabel,
                        secondLabel: postDetailViewModel.secondLabel,
                        selectedTab: $postDetailViewModel.selectedProductTab
                    )
                }

                if let product = postDetailViewModel.displayedProduct {
                    PostDetailProductInfo(product: product)
                }
            }

            if post.firstProduct != nil {
                PostDetailVoteButtons(
                    firstLabel: postDetailViewModel.firstLabel,
                    secondLabel: postDetailViewModel.secondLabel,
                    votedSide: post.votedSide,
                    firstPercentage: post.firstPercentage ?? 0,
                    secondPercentage: post.secondPercentage ?? 0,
                    myProfileImageUrl: postDetailViewModel.myProfileImageUrl,
                    onVote: onVote
                )
                .frame(height: 48)
            }
        }
    }
}

#Preview("AB 픽") {
    let post = PostDetail(
        id: 1,
        type: .ab,
        category: "패션/잡화",
        title: "이거 흰색? 검은색?",
        description: "",
        createdAt: Date(),
        commentCount: 0,
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
    )
    let viewModel = PostDetailViewModel(voteType: .ab)
    // displayedProduct는 뷰모델 자체의 post를 읽으므로, 프리뷰에서 직접 채워줘야
    // 상품 정보(가격/링크)가 보인다.
    let _ = { viewModel.post = post }()

    PostDetailProductVoteSection(
        post: post,
        postDetailViewModel: viewModel,
        onVote: { _ in }
    )
    .padding()
}

#Preview("찬반 픽") {
    let post = PostDetail(
        id: 2,
        type: .forAgainst,
        category: "패션/잡화",
        title: "이 신발 살까 말까?",
        description: "",
        createdAt: Date(),
        commentCount: 0,
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
                PostDetailProduct(id: 1, name: "나이키 에어포스 흰색", price: 135_000, purchaseURL: "11pcs.11st.co.kr/...", imageUrl: nil, displayOrder: 1)
            ],
            options: [
                PostDetailVoteOption(optionId: 1, label: nil, productId: 1, displayOrder: 1, voteCount: nil, percentage: nil),
                PostDetailVoteOption(optionId: 2, label: nil, productId: nil, displayOrder: 2, voteCount: nil, percentage: nil)
            ]
        )
    )
    let viewModel = PostDetailViewModel(voteType: .forAgainst)
    let _ = { viewModel.post = post }()

    PostDetailProductVoteSection(
        post: post,
        postDetailViewModel: viewModel,
        onVote: { _ in }
    )
    .padding()
}
