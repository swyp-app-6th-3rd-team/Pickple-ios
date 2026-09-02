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
                voteCount: 0,
                commentCount: 1,
                createdAt: Date().addingTimeInterval(-60 * 60 * 24)
            ),
        ]
    }
}
