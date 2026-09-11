//
//  MockPostDetailRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Foundation

struct MockPostDetailRepository: PostDetailRepository {
    let type: VoteType

    func deletePost() async throws {}

    func fetchPostDetail() async throws -> PostDetail {
        let author = (
            id: 1,
            nickname: "닉네임",
            profileImageUrl: URL(string: "https://picsum.photos/200"),
            gradeLevel: 5,
            gradeName: "LV.5"
        )
        let productImage = URL(string: "https://picsum.photos/600/600")

        switch type {
        case .forAgainst:
            return PostDetail(
                id: 1,
                type: .forAgainst,
                category: "패션/잡화",
                title: "나이키 에어포스 흰색",
                description: "데일리로 신을건데 나이키 에어포스 흰색 어때? 흰색 때타고 별로이려나? 검은색은 이미 있어서 이번에 흰 색도 사보려는데 어떻게 생각해?",
                createdAt: Date().addingTimeInterval(-60 * 23),
                commentCount: 3,
                authorId: author.id,
                authorNickname: author.nickname,
                authorProfileImageUrl: author.profileImageUrl,
                authorGradeLevel: author.gradeLevel,
                authorGradeName: author.gradeName,
                authorRanking: 12,
                isMine: true,
                vote: PostDetailVote(
                    voted: false,
                    selectedOptionId: nil,
                    voterCount: 3,
                    products: [
                        PostDetailProduct(id: 1, name: "나이키 에어포스 흰색", price: 135_000, purchaseURL: "11pcs.11st.co.kr/?appLnkWyCd=04&prdNo=7853...", imageUrl: productImage, displayOrder: 1)
                    ],
                    options: [
                        PostDetailVoteOption(optionId: 1, label: PostDetailStrings.voteSideFor, productId: nil, displayOrder: 1, voteCount: nil, percentage: nil),
                        PostDetailVoteOption(optionId: 2, label: PostDetailStrings.voteSideAgainst, productId: nil, displayOrder: 2, voteCount: nil, percentage: nil)
                    ]
                )
            )
        case .ab:
            return PostDetail(
                id: 2,
                type: .ab,
                category: "패션/잡화",
                title: "이거 흰색? 검은색?",
                description: "데일리로 신을건데 나이키 에어포스 흰색 어때? 흰색 때타고 별로이려나? 검은색은 이미 있어서 이번에 흰 색도 사보려는데 어떻게 생각해?",
                createdAt: Date().addingTimeInterval(-60 * 23),
                commentCount: 3,
                authorId: author.id,
                authorNickname: author.nickname,
                authorProfileImageUrl: author.profileImageUrl,
                authorGradeLevel: author.gradeLevel,
                authorGradeName: author.gradeName,
                authorRanking: 12,
                isMine: true,
                vote: PostDetailVote(
                    voted: false,
                    selectedOptionId: nil,
                    voterCount: 3,
                    products: [
                        PostDetailProduct(id: 1, name: "나이키 에어포스 흰색", price: 135_000, purchaseURL: "11pcs.11st.co.kr/?appLnkWyCd=04&prdNo=7853...", imageUrl: productImage, displayOrder: 1),
                        PostDetailProduct(id: 2, name: "나이키 에어포스 검은색", price: 135_000, purchaseURL: "11pcs.11st.co.kr/?appLnkWyCd=04&prdNo=7853...", imageUrl: productImage, displayOrder: 2)
                    ],
                    options: [
                        PostDetailVoteOption(optionId: 1, label: nil, productId: 1, displayOrder: 1, voteCount: nil, percentage: nil),
                        PostDetailVoteOption(optionId: 2, label: nil, productId: 2, displayOrder: 2, voteCount: nil, percentage: nil)
                    ]
                )
            )
        case .text:
            return PostDetail(
                id: 3,
                type: .text,
                category: "패션/잡화",
                title: "나이키 에어포스 흰색으로 살까?",
                description: "데일리로 신을건데 나이키 에어포스 흰색 어때? 흰색 때타고 별로이려나? 검은색은 이미 있어서 이번에 흰 색도 사보려는데 어떻게 생각해?",
                createdAt: Date().addingTimeInterval(-60 * 23),
                commentCount: 0,
                authorId: author.id,
                authorNickname: author.nickname,
                authorProfileImageUrl: author.profileImageUrl,
                authorGradeLevel: author.gradeLevel,
                authorGradeName: author.gradeName,
                authorRanking: 12,
                isMine: true,
                vote: nil
            )
        }
    }
}
