//
//  MockPostDetailRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Foundation

struct MockPostDetailRepository: PostDetailRepository {
    let type: VoteType

    func fetchPostDetail() async -> PostDetail {
        let product = PostDetailProduct(
            name: "나이키 에어포스 흰색",
            price: 135_000,
            purchaseURL: "11pcs.11st.co.kr/?appLnkWyCd=04&prdNo=7853..."
        )

        switch type {
        case .forAgainst:
            return PostDetail(
                id: UUID(),
                type: .forAgainst,
                category: "패션/잡화",
                title: "나이키 에어포스 흰색",
                description: "데일리로 신을건데 나이키 에어포스 흰색 어때? 흰색 때타고 별로이려나? 검은색은 이미 있어서 이번에 흰 색도 사보려는데 어떻게 생각해?",
                images: ["McokMyPostPicture", "McokMyPostPicture", "McokMyPostPicture"],
                authorNickname: "닉네임",
                authorLevel: 5,
                authorProfileImageName: "PickpleProfileSample",
                isMine: true,
                createdAt: Date().addingTimeInterval(-60 * 23),
                participantCount: 3,
                firstProduct: product,
                secondProduct: nil
            )
        case .ab:
            return PostDetail(
                id: UUID(),
                type: .ab,
                category: "패션/잡화",
                title: "이거 흰색? 검은색?",
                description: "데일리로 신을건데 나이키 에어포스 흰색 어때? 흰색 때타고 별로이려나? 검은색은 이미 있어서 이번에 흰 색도 사보려는데 어떻게 생각해?",
                images: ["McokMyPostPicture", "McokMyPostPicture", "McokMyPostPicture"],
                authorNickname: "닉네임",
                authorLevel: 5,
                authorProfileImageName: "PickpleProfileSample",
                isMine: true,
                createdAt: Date().addingTimeInterval(-60 * 23),
                participantCount: 3,
                firstProduct: product,
                secondProduct: PostDetailProduct(name: "나이키 에어포스 검은색", price: 135_000, purchaseURL: "11pcs.11st.co.kr/?appLnkWyCd=04&prdNo=7853...")
            )
        case .text:
            return PostDetail(
                id: UUID(),
                type: .text,
                category: "패션/잡화",
                title: "나이키 에어포스 흰색으로 살까?",
                description: "데일리로 신을건데 나이키 에어포스 흰색 어때? 흰색 때타고 별로이려나? 검은색은 이미 있어서 이번에 흰 색도 사보려는데 어떻게 생각해?",
                images: [],
                authorNickname: "닉네임",
                authorLevel: 5,
                authorProfileImageName: "PickpleProfileSample",
                isMine: true,
                createdAt: Date().addingTimeInterval(-60 * 23),
                participantCount: 0,
                firstProduct: nil,
                secondProduct: nil
            )
        }
    }
}
