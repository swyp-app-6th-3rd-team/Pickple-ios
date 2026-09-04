//
//  PostDetailProductVoteSection.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

// A/B 탭 선택 + 상품 정보 + 투표 버튼까지, 게시글 상세의 상품/투표 블록.
// 일반 게시글에서는 상품 정보가 없어서 비어 보인다(호출부에서 firstProduct 존재 여부로 감싸는 걸 권장).
struct PostDetailProductVoteSection: View {
    let post: PostDetail
    @ObservedObject var postDetailViewModel: PostDetailViewModel
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
                    votedSide: postDetailViewModel.votedSide,
                    firstPercentage: PostDetailViewModel.firstVotePercentage,
                    secondPercentage: PostDetailViewModel.secondVotePercentage,
                    onVote: onVote
                )
            }
        }
    }
}

#Preview {
    PostDetailProductVoteSection(
        post: PostDetail(
            id: UUID(),
            type: .ab,
            category: "패션/잡화",
            title: "이거 흰색? 검은색?",
            description: "",
            images: [],
            authorNickname: "닉네임",
            authorLevel: 5,
            authorProfileImageName: "PickpleProfileSample",
            isMine: true,
            createdAt: Date(),
            participantCount: 3,
            firstProduct: PostDetailProduct(name: "나이키 에어포스 흰색", price: 135_000, purchaseURL: "11pcs.11st.co.kr/..."),
            secondProduct: PostDetailProduct(name: "나이키 에어포스 검은색", price: 135_000, purchaseURL: "11pcs.11st.co.kr/...")
        ),
        postDetailViewModel: PostDetailViewModel(voteType: .ab),
        onVote: { _ in }
    )
    .padding()
}
