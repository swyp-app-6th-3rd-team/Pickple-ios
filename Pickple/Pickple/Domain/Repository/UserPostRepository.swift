//
//  UserPostRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//

// GET /users/me/activities 한 조각의 결과. cursor 페이지네이션용.
struct UserPostPage {
    let items: [PostSummary]
    let nextCursor: String?
    let hasNext: Bool
}

protocol UserPostRepository {
    func fetchMyPosts() async throws -> [PostSummary]
    func fetchVotedPosts(cursor: String?) async -> UserPostPage
    // 댓글 목록 API(GET /users/me/activities?type=COMMENT)가 게시글 카드만 주고 내가 쓴 댓글의
    // 실제 내용은 안 줘서(2026-09-06 OAS 확인), 게시글마다 댓글 목록을 추가로 불러 조합한다 —
    // RemoteUserPostRepository.fetchCommentedPosts() 참고.
    func fetchCommentedPosts() async -> [MyCommentActivity]
    func fetchWrittenPosts(cursor: String?) async -> UserPostPage
}
