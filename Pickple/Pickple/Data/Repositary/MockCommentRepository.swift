//
//  MockCommentRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Foundation

struct MockCommentRepository: CommentRepository {
    func fetchComments() async -> [Comment] {
        [
            Comment(id: UUID(), authorNickname: "픽플고인물", authorLevel: 5, authorProfileImageName: "PickpleProfileSample", content: "이거 너무 좋아요 제가 뭐뭐 써봤는데 좋습니다", createdAt: Date().addingTimeInterval(-60 * 23), pickCount: 3),
            Comment(id: UUID(), authorNickname: "픽플고인물", authorLevel: 1, authorProfileImageName: "PickpleProfileSample", content: "이거 너무 좋아요 제가 뭐뭐 써봤는데 좋습니다", createdAt: Date().addingTimeInterval(-60 * 23), pickCount: 3),
            Comment(id: UUID(), authorNickname: "픽플고인물", authorLevel: 2, authorProfileImageName: "PickpleProfileSample", content: "이거 너무 좋아요 제가 뭐뭐 써봤는데 좋습니다", createdAt: Date().addingTimeInterval(-60 * 23), pickCount: 3),
        ]
    }
}
