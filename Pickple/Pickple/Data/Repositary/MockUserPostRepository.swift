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
                id: UUID(),
                type: .forAgainst,
                category: "전자제품",
                title: "무선 이어폰 살까 말까",
                imageName: "McokMyPostPicture",
                authorNickname: "픽플닉네임",
                authorLevel: 1,
                voteCount: 12,
                commentCount: 4,
                createdAt: Date().addingTimeInterval(-60 * 5)
            ),
            PostSummary(
                id: UUID(),
                type: .compare,
                category: "패션/잡화",
                title: "운동화 A vs B",
                imageName: "McokMyPostPicture",
                authorNickname: "픽플닉네임",
                authorLevel: 1,
                voteCount: 8,
                commentCount: 2,
                createdAt: Date().addingTimeInterval(-60 * 60 * 3)
            ),
            PostSummary(
                id: UUID(),
                type: .text,
                category: "생활용품",
                title: "이 청소기 써본 사람?",
                imageName: "McokMyPostPicture",
                authorNickname: "픽플닉네임",
                authorLevel: 1,
                voteCount: 0,
                commentCount: 1,
                createdAt: Date().addingTimeInterval(-60 * 60 * 24)
            ),
        ]
    }

    func fetchVotedPosts() async -> [PostSummary] {
        [
            PostSummary(
                id: UUID(),
                type: .forAgainst,
                category: "전자제품",
                title: "노트북 살까 말까",
                imageName: "McokMyPostPicture",
                authorNickname: "라떼한잔",
                authorLevel: 3,
                voteCount: 24,
                commentCount: 9,
                createdAt: Date().addingTimeInterval(-60 * 30)
            ),
            PostSummary(
                id: UUID(),
                type: .compare,
                category: "화장품/뷰티",
                title: "선크림 A vs B",
                imageName: "McokMyPostPicture",
                authorNickname: "여름햇살",
                authorLevel: 5,
                voteCount: 15,
                commentCount: 3,
                createdAt: Date().addingTimeInterval(-60 * 60 * 6)
            ),
        ]
    }

    func fetchCommentedPosts() async -> [PostSummary] {
        [
            PostSummary(
                id: UUID(),
                type: .text,
                category: "생활용품",
                title: "가습기 추천 좀요",
                imageName: "McokMyPostPicture",
                authorNickname: "구름위산책",
                authorLevel: 2,
                voteCount: 3,
                commentCount: 18,
                createdAt: Date().addingTimeInterval(-60 * 60 * 2)
            ),
            PostSummary(
                id: UUID(),
                type: .forAgainst,
                category: "패션/잡화",
                title: "이 가방 살까 말까",
                imageName: "McokMyPostPicture",
                authorNickname: "냥냥펀치",
                authorLevel: 4,
                voteCount: 7,
                commentCount: 5,
                createdAt: Date().addingTimeInterval(-60 * 60 * 30)
            ),
        ]
    }

    func fetchWrittenPosts() async -> [PostSummary] {
        await fetchMyPosts()
    }
}
