//
//  MockCommentRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

struct MockCommentRepository: CommentRepository {
    func fetchComments() async -> [Comment] {
        []
    }
}
