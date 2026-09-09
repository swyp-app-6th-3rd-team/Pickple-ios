//
//  RemoteUserPostRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/5/26.
//

import Foundation

struct ActivityItemDTO: Decodable {
    let id: Int
    let type: String
    let category: String
    let title: String
    let description: String?
    let commentCount: Int
    let voteCount: Int?
    let thumbnailUrl: String?
    let createdAt: Date
}

// GET /users/me/activities(type=VOTE|COMMENT|POST) 응답. GET /posts의 content 항목 필드 +
// activityAt(내가 이 게시글에 활동한 시각) — 커서 페이징 지원하지만, 지금 UserPostRepository
// 프로토콜은 커서를 안 받아서 첫 페이지만 가져온다.
private struct ActivityListItemDTO: Decodable {
    let id: Int
    let type: String
    let category: String
    let title: String
    let description: String?
    let commentCount: Int
    let voteCount: Int?
    let thumbnailUrl: String?
    let createdAt: Date
    let activityAt: Date?
}

private struct ActivityListResponseDTO: Decodable {
    let content: [ActivityListItemDTO]
    let nextCursor: String?
    let hasNext: Bool
}

struct RemoteUserPostRepository: UserPostRepository {
    let apiClient: APIClientProtocol
    private let fallback = MockUserPostRepository()

    func fetchMyPosts() async throws -> [PostSummary] {
        let endpoint = APIEndpoint(method: .get, path: "/users/me/posts/recent", requiresAuth: true)
        let dtos: [ActivityItemDTO] = try await apiClient.request(endpoint)
        return dtos.map(Self.toDomain)
    }

    func fetchVotedPosts() async -> [PostSummary] {
        await fetchActivities(type: "VOTE")
    }

    // GET /users/me/activities(type=COMMENT)는 "게시글 카드"만 주고 내가 쓴 댓글의 실제 내용은
    // 안 내려줘서(2026-09-06 OAS 확인), MyCommentActivity(댓글 내용 + 참조 게시글)를 채울 방법이
    // 없다. 백엔드가 댓글 내용을 포함해서 내려주기 전까진 Mock 유지.
    func fetchCommentedPosts() async -> [MyCommentActivity] {
        await fallback.fetchCommentedPosts()
    }

    func fetchWrittenPosts() async -> [PostSummary] {
        await fetchActivities(type: "POST")
    }

    private func fetchActivities(type: String) async -> [PostSummary] {
        let endpoint = APIEndpoint(
            method: .get,
            path: "/users/me/activities",
            queryItems: [URLQueryItem(name: "type", value: type)],
            requiresAuth: true
        )
        guard let response: ActivityListResponseDTO = try? await apiClient.request(endpoint) else { return [] }
        return response.content.map(Self.toDomain)
    }

    // "내가 올린/투표한/작성한 글" 목록이라 서버가 작성자 정보를 따로 안 준다(항상 본인 글이라
    // 자명해서, API_SPEC 기준) — authorNickname/authorLevel은 nil로 두고, 화면 쪽에서 작성자
    // 정보를 아예 표시하지 않는다.
    private static func toDomain(_ dto: ActivityItemDTO) -> PostSummary {
        .fromServerFields(
            id: dto.id,
            type: dto.type,
            category: dto.category,
            title: dto.title,
            description: dto.description,
            thumbnailUrl: dto.thumbnailUrl,
            voteCount: dto.voteCount,
            commentCount: dto.commentCount,
            createdAt: dto.createdAt
        )
    }

    private static func toDomain(_ dto: ActivityListItemDTO) -> PostSummary {
        .fromServerFields(
            id: dto.id,
            type: dto.type,
            category: dto.category,
            title: dto.title,
            description: dto.description,
            thumbnailUrl: dto.thumbnailUrl,
            voteCount: dto.voteCount,
            commentCount: dto.commentCount,
            createdAt: dto.activityAt ?? dto.createdAt
        )
    }
}
