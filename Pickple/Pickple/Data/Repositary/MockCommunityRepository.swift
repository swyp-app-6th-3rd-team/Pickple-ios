//
//  MockCommunityRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Foundation

struct MockCommunityRepository: CommunityRepository {
    func fetchPosts() async -> [PostSummary] {
        [
            PostSummary(
                id: UUID(),
                type: .forAgainst,
                category: "패션/잡화",
                title: "나이키 에어포스 흰색으로 살까?",
                description: "데일리로 신을건데 나이키 에어포스 흰색 어때? 흰색 때타고 별로이려나? 검은색은 이미 있어서 이번엔 흰 색도 사보려는데 어떻게 생각해?",
                imageName: "McokMyPostPicture",
                authorNickname: "닉네임",
                authorLevel: 5,
                authorProfileImageName: "PickpleProfileSample",
                voteCount: 3,
                commentCount: 1,
                createdAt: Date().addingTimeInterval(-60 * 5)
            ),
            PostSummary(
                id: UUID(),
                type: .forAgainst,
                category: "패션/잡화",
                title: "나이키 에어포스 흰색으로 살까?",
                description: "데일리로 신을건데 나이키 에어포스 흰색 어때? 흰색 때타고 별로이려나? 검은색은 이미 있어서 이번엔 흰 색도 사보려는데 어떻게 생각해?",
                imageName: "McokMyPostPicture",
                authorNickname: "닉네임",
                authorLevel: 5,
                authorProfileImageName: "PickpleProfileSample",
                voteCount: 3,
                commentCount: 1,
                createdAt: Date().addingTimeInterval(-60 * 8)
            ),
            PostSummary(
                id: UUID(),
                type: .ab,
                category: "전자제품",
                title: "무선 이어폰 이거 vs 저거",
                description: "둘 다 후기가 갈려서 고민이에요. 통화 품질 위주로 보는데 뭐가 나을까요?",
                imageName: "McokMyPostPicture",
                authorNickname: "라떼한잔",
                authorLevel: 3,
                authorProfileImageName: "PickpleProfileSample",
                voteCount: 12,
                commentCount: 4,
                createdAt: Date().addingTimeInterval(-60 * 60 * 3)
            ),
            PostSummary(
                id: UUID(),
                type: .text,
                category: "생활용품",
                title: "이 청소기 써본 사람?",
                description: "무선 청소기 사려는데 흡입력이랑 배터리 오래가는 제품 추천 좀요.",
                imageName: "McokMyPostPicture",
                authorNickname: "구름위산책",
                authorLevel: 2,
                authorProfileImageName: "PickpleProfileSample",
                voteCount: 0,
                commentCount: 1,
                createdAt: Date().addingTimeInterval(-60 * 60 * 24)
            ),
            PostSummary(
                id: UUID(),
                type: .forAgainst,
                category: "뷰티",
                title: "이 선크림 살까 말까",
                description: "여름 다가오는데 백탁 없고 산뜻한 걸로 고르려니 고민이에요.",
                imageName: "McokMyPostPicture",
                authorNickname: "여름햇살",
                authorLevel: 4,
                authorProfileImageName: "PickpleProfileSample",
                voteCount: 15,
                commentCount: 3,
                createdAt: Date().addingTimeInterval(-60 * 60 * 6)
            ),
        ]
    }
}
