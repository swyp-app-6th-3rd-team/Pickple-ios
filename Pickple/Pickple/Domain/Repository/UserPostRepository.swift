//
//  UserPostRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//

// GET /users/me/activities/votes|comments|posts 한 조각의 결과. cursor 페이지네이션용.
// 커서는 경로마다 다르므로(API_SPEC 참고) 세 목록 사이에서 커서를 섞어 쓰면 안 된다.
struct UserPostPage {
    let items: [PostSummary]
    let nextCursor: String?
    let hasNext: Bool
}

protocol UserPostRepository {
    func fetchMyPosts() async throws -> [PostSummary]
    func fetchVotedPosts(cursor: String?) async -> UserPostPage
    func fetchCommentedPosts() async -> [MyCommentActivity]
    func fetchWrittenPosts(cursor: String?) async -> UserPostPage
}
