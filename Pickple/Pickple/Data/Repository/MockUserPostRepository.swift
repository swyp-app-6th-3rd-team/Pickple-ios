//
//  MockUserPostRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//
import Foundation

struct MockUserPostRepository: UserPostRepository {
    func fetchMyPosts() async -> [PostSummary] {
        [
            PostSummary(
                id: 1,
                type: .forAgainst,
                category: "전자제품",
                title: "무선 이어폰 살까 말까",
                description: "요즘 유선 이어폰 선 꼬이는게 스트레스인데 무선으로 넘어갈까 고민이에요.",
                thumbnailUrl: nil,
                authorNickname: "픽플닉네임",
                authorLevel: 1,
                authorProfileImageUrl: nil,
                voteCount: 12,
                commentCount: 4,
                createdAt: Date().addingTimeInterval(-60 * 5)
            ),
            PostSummary(
                id: 2,
                type: .ab,
                category: "패션/잡화",
                title: "운동화 A vs B",
                description: "둘 다 예쁜데 실착용했을 때 어떤 게 더 편할지 의견 부탁드려요.",
                thumbnailUrl: nil,
                authorNickname: "픽플닉네임",
                authorLevel: 1,
                authorProfileImageUrl: nil,
                voteCount: 8,
                commentCount: 2,
                createdAt: Date().addingTimeInterval(-60 * 60 * 3)
            ),
            PostSummary(
                id: 3,
                type: .text,
                category: "생활용품",
                title: "이 청소기 써본 사람?",
                description: "무선 청소기 사려는데 흡입력이랑 배터리 오래가는 제품 추천 좀요.",
                thumbnailUrl: nil,
                authorNickname: "픽플닉네임",
                authorLevel: 1,
                authorProfileImageUrl: nil,
                voteCount: 0,
                commentCount: 1,
                createdAt: Date().addingTimeInterval(-60 * 60 * 24)
            ),
        ]
    }

    func fetchVotedPosts() async -> [PostSummary] {
        [
            PostSummary(
                id: 101,
                type: .forAgainst,
                category: "전자제품",
                title: "노트북 살까 말까",
                description: "재택근무용으로 하나 더 살까 하는데 이미 있는 거로 버텨야 할지 고민이네요.",
                thumbnailUrl: nil,
                authorNickname: "라떼한잔",
                authorLevel: 3,
                authorProfileImageUrl: nil,
                voteCount: 24,
                commentCount: 9,
                createdAt: Date().addingTimeInterval(-60 * 30),
                voteResult: PostVoteResult(firstLabel: MyActivityStrings.voteSideFor, secondLabel: MyActivityStrings.voteSideAgainst, firstPercentage: 70, secondPercentage: 30, votedSide: .first)
            ),
            PostSummary(
                id: 102,
                type: .ab,
                category: "화장품/뷰티",
                title: "선크림 A vs B",
                description: "여름 다가오는데 백탁 없고 산뜻한 걸로 고르려니 둘 중 뭐가 나을지 모르겠어요.",
                thumbnailUrl: nil,
                authorNickname: "여름햇살",
                authorLevel: 5,
                authorProfileImageUrl: nil,
                voteCount: 15,
                commentCount: 3,
                createdAt: Date().addingTimeInterval(-60 * 60 * 6),
                voteResult: PostVoteResult(firstLabel: MyActivityStrings.abFirstLabel, secondLabel: MyActivityStrings.abSecondLabel, firstPercentage: 40, secondPercentage: 60, votedSide: .second)
            ),
            PostSummary(
                id: 103,
                type: .forAgainst,
                category: "생활용품",
                title: "가습기 살까 말까",
                description: "건조한 계절이라 하나 들이려는데 관리 편한 제품인지 모르겠어요.",
                thumbnailUrl: nil,
                authorNickname: "구름위산책",
                authorLevel: 2,
                authorProfileImageUrl: nil,
                voteCount: 6,
                commentCount: 2,
                createdAt: Date().addingTimeInterval(-60 * 60 * 12),
                voteResult: PostVoteResult(firstLabel: MyActivityStrings.voteSideFor, secondLabel: MyActivityStrings.voteSideAgainst, firstPercentage: 30, secondPercentage: 70, votedSide: .second)
            ),
            PostSummary(
                id: 104,
                type: .ab,
                category: "패션/잡화",
                title: "가방 A vs B",
                description: "예쁘긴 한데 활용도가 낮을까봐 고민돼요. 다들 이런 디자인 잘 들고 다니시나요?",
                thumbnailUrl: nil,
                authorNickname: "냥냥펀치",
                authorLevel: 4,
                authorProfileImageUrl: nil,
                voteCount: 20,
                commentCount: 5,
                createdAt: Date().addingTimeInterval(-60 * 60 * 30),
                voteResult: PostVoteResult(firstLabel: MyActivityStrings.abFirstLabel, secondLabel: MyActivityStrings.abSecondLabel, firstPercentage: 90, secondPercentage: 10, votedSide: .first)
            ),
        ]
    }

    func fetchCommentedPosts() async -> [MyCommentActivity] {
        [
            MyCommentActivity(
                id: 301,
                content: "그것도 괜찮아보이지만 차라리 같은 흰 색으로 두 켤레 살거면 다른 모델로 사는편이 좋지 않을까?",
                pickCount: 3,
                createdAt: Date().addingTimeInterval(-60 * 5),
                referencedPost: MyCommentActivityPostReference(
                    id: 201,
                    type: .forAgainst,
                    title: "나이키 에어포스 흰색으로 살까?",
                    thumbnailUrl: nil
                )
            ),
            MyCommentActivity(
                id: 302,
                content: "나라면 굳이 같은걸로 살 것 같지는 않아요, 룩마다 다르게 신는 재미가 있어서.",
                pickCount: 3,
                createdAt: Date().addingTimeInterval(-60 * 5),
                referencedPost: MyCommentActivityPostReference(
                    id: 202,
                    type: .ab,
                    title: "OOTD 몇 번 룩이 가장 좋아요?",
                    thumbnailUrl: nil
                )
            ),
            MyCommentActivity(
                id: 303,
                content: "○○ 그거 맞음",
                pickCount: 3,
                createdAt: Date().addingTimeInterval(-60 * 5),
                referencedPost: MyCommentActivityPostReference(
                    id: 201,
                    type: .forAgainst,
                    title: "나이키 에어포스 흰색으로 살까?",
                    thumbnailUrl: nil
                )
            ),
        ]
    }

    func fetchWrittenPosts() async -> [PostSummary] {
        await fetchMyPosts()
    }
}
