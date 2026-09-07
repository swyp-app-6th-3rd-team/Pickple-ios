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

    private static func toDomain(_ dto: ActivityItemDTO) -> PostSummary {
        PostSummary(
            id: dto.id,
            type: VoteType(serverType: dto.type),
            category: PostCategoryLabel.label(for: dto.category),
            title: dto.title,
            description: dto.description ?? "",
            thumbnailUrl: dto.thumbnailUrl.flatMap(URL.init(string:)),
            // "내가 올린 글" 목록이라 서버가 작성자 정보를 따로 안 준다(본인이 자명해서) —
            // 실제 내 닉네임/레벨로 채우려면 별도로 내 프로필을 조회해서 합쳐야 한다. 이번 범위 밖.
            authorNickname: "나",
            authorLevel: 1,
            authorProfileImageUrl: nil,
            voteCount: dto.voteCount ?? 0,
            commentCount: dto.commentCount,
            createdAt: dto.createdAt
        )
    }

    private static func toDomain(_ dto: ActivityListItemDTO) -> PostSummary {
        PostSummary(
            id: dto.id,
            type: VoteType(serverType: dto.type),
            category: PostCategoryLabel.label(for: dto.category),
            title: dto.title,
            description: dto.description ?? "",
            thumbnailUrl: dto.thumbnailUrl.flatMap(URL.init(string:)),
            authorNickname: "나",
            authorLevel: 1,
            authorProfileImageUrl: nil,
            voteCount: dto.voteCount ?? 0,
            commentCount: dto.commentCount,
            createdAt: dto.activityAt ?? dto.createdAt
        )
    }
}
