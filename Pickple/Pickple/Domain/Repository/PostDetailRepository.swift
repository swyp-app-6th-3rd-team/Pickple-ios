//
//  PostDetailRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

protocol PostDetailRepository {
    func fetchPostDetail() async throws -> PostDetail
    // 작성자만 가능한 소프트 삭제 — 성공하면 이후 조회는 404, 투표·댓글은 거절된다(API_SPEC.md).
    func deletePost() async throws
}
