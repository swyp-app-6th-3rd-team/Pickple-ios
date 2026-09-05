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
            Comment(id: 1, authorNickname: "픽플고인물", authorLevel: 5, authorProfileImageUrl: nil, content: "이거 너무 좋아요 제가 뭐뭐 써봤는데 좋습니다", createdAt: Date().addingTimeInterval(-60 * 23), pickCount: 3, mine: false),
            Comment(id: 2, authorNickname: "픽플고인물", authorLevel: 1, authorProfileImageUrl: nil, content: "이거 너무 좋아요 제가 뭐뭐 써봤는데 좋습니다", createdAt: Date().addingTimeInterval(-60 * 23), pickCount: 3, mine: false),
            Comment(id: 3, authorNickname: "나", authorLevel: 2, authorProfileImageUrl: nil, content: "이거 너무 좋아요 제가 뭐뭐 써봤는데 좋습니다", createdAt: Date().addingTimeInterval(-60 * 23), pickCount: 3, mine: true),
        ]
    }

    func postComment(content: String) async {}
    func editComment(id: Int, content: String) async {}
    func deleteComment(id: Int) async {}
    func pickComment(id: Int) async {}
}
