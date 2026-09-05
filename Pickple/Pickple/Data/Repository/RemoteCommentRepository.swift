//
//  RemoteCommentRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/5/26.
//

import Foundation

struct CommentDTO: Decodable {
    let id: Int
    let authorId: Int
    let profileImageUrl: String?
    let nickname: String?
    let createdAt: Date
    let content: String
    let onePickCount: Int
    let mine: Bool
}

struct CommentListDTO: Decodable {
    let commentCount: Int
    let comments: [CommentDTO]
}

struct CommentContentRequestDTO: Encodable {
    let content: String
}

// GET /posts/{postId}/comments 등 postId가 필요한 요청은 이 레포지토리 인스턴스에
// postId를 생성 시점에 고정해서 쓴다(MockPostDetailRepository(type:)와 동일한 패턴).
struct RemoteCommentRepository: CommentRepository {
    let apiClient: APIClientProtocol
    let postId: Int

    func fetchComments() async throws -> [Comment] {
        let endpoint = APIEndpoint(method: .get, path: "/posts/\(postId)/comments", requiresAuth: false)
        let dto: CommentListDTO = try await apiClient.request(endpoint)
        return dto.comments.map(Self.toDomain)
    }

    func postComment(content: String) async throws {
        let body = try JSONEncoder().encode(CommentContentRequestDTO(content: content))
        let endpoint = APIEndpoint(method: .post, path: "/posts/\(postId)/comments", body: body, requiresAuth: true)
        try await apiClient.requestVoid(endpoint)
    }

    func editComment(id: Int, content: String) async throws {
        let body = try JSONEncoder().encode(CommentContentRequestDTO(content: content))
        let endpoint = APIEndpoint(method: .patch, path: "/comments/\(id)", body: body, requiresAuth: true)
        try await apiClient.requestVoid(endpoint)
    }

    func deleteComment(id: Int) async throws {
        let endpoint = APIEndpoint(method: .delete, path: "/comments/\(id)", requiresAuth: true)
        try await apiClient.requestVoid(endpoint)
    }

    func pickComment(id: Int) async throws {
        let endpoint = APIEndpoint(method: .post, path: "/comments/\(id)/pick", requiresAuth: true)
        try await apiClient.requestVoid(endpoint)
    }

    // TODO: 댓글 작성자 등급(1~5)이 응답에 없어서 1로 고정 — 다른 화면과 동일한 임시 처리.
    private static func toDomain(_ dto: CommentDTO) -> Comment {
        Comment(
            id: dto.id,
            authorNickname: dto.nickname ?? "",
            authorLevel: 1,
            authorProfileImageUrl: dto.profileImageUrl.flatMap(URL.init(string:)),
            content: dto.content,
            createdAt: dto.createdAt,
            pickCount: dto.onePickCount,
            mine: dto.mine
        )
    }
}
