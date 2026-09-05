//
//  CommentRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

protocol CommentRepository {
    func fetchComments() async throws -> [Comment]
    // 작성/수정 응답은 서버가 {id, content}만 줘서 다른 필드(작성자/mine 등)를 채울 수 없다 —
    // 성공하면 호출부가 fetchComments()로 목록을 다시 받아 반영한다.
    func postComment(content: String) async throws
    func editComment(id: Int, content: String) async throws
    func deleteComment(id: Int) async throws
    func pickComment(id: Int) async throws
}
