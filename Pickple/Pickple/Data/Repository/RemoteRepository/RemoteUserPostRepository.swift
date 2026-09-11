//
//  RemoteUserPostRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/5/26.
//

import Foundation

// GET /users/me/posts/recent와 GET /users/me/activities(type=VOTE|COMMENT|POST) 둘 다
// GET /posts의 content 항목과 같은 필드를 준다. 후자만 activityAt(내가 이 게시글에 활동한
// 시각)을 추가로 주는데, 전자엔 그 키 자체가 없어서 Optional로 두면 자연히 nil로 디코딩된다
// — 두 응답이 같은 구조라 DTO 하나로 공유한다.
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
    let activityAt: Date?
}

private struct ActivityListResponseDTO: Decodable {
    let content: [ActivityItemDTO]
    let nextCursor: String?
    let hasNext: Bool
}

struct RemoteUserPostRepository: UserPostRepository {
    let apiClient: APIClientProtocol

    func fetchMyPosts() async throws -> [PostSummary] {
        let endpoint = APIEndpoint(method: .get, path: "/users/me/posts/recent", requiresAuth: true)
        let dtos: [ActivityItemDTO] = try await apiClient.request(endpoint)
        return dtos.map(Self.toDomain)
    }

    func fetchVotedPosts(cursor: String?) async -> UserPostPage {
        await fetchActivities(type: "VOTE", cursor: cursor)
    }

    // GET /users/me/activities(type=COMMENT)는 "게시글 카드"만 주고 내가 쓴 댓글의 실제 내용은
    // 안 내려줘서(2026-09-06 OAS 확인), 댓글 내용을 채우려면 게시글마다 GET /posts/{id}/comments를
    // 추가로 불러 mine==true인 댓글을 걸러야 한다(N+1). "나의 활동" 탭은 개인 활동 내역이라
    // 대상 게시글 수가 자연히 작아서(전체 피드처럼 반복적으로 많이 불러오는 화면이 아님) 이
    // 비용을 감당하기로 함. 한 게시글에 내 댓글이 여러 개면 게시글당 한 줄이 아니라 댓글마다
    // 한 줄씩 보여준다(활동 목록의 "참여 게시글 수" 집계와는 다른 기준).
    func fetchCommentedPosts() async -> [MyCommentActivity] {
        var commentedPosts: [PostSummary] = []
        var cursor: String?
        while true {
            let page = await fetchActivities(type: "COMMENT", cursor: cursor)
            commentedPosts += page.items
            guard page.hasNext, let next = page.nextCursor else { break }
            cursor = next
        }

        var activities: [MyCommentActivity] = []
        for post in commentedPosts {
            let commentRepository = RemoteCommentRepository(apiClient: apiClient, postId: post.id)
            guard let comments = try? await commentRepository.fetchComments() else { continue }
            for comment in comments where comment.mine {
                activities.append(MyCommentActivity(
                    id: comment.id,
                    content: comment.content,
                    pickCount: comment.pickCount,
                    createdAt: comment.createdAt,
                    referencedPost: MyCommentActivityPostReference(
                        id: post.id,
                        type: post.type,
                        title: post.title,
                        thumbnailUrl: post.thumbnailUrl,
                        voteCount: post.voteCount,
                        commentCount: post.commentCount
                    )
                ))
            }
        }
        return activities.sorted { $0.createdAt > $1.createdAt }
    }

    func fetchWrittenPosts(cursor: String?) async -> UserPostPage {
        await fetchActivities(type: "POST", cursor: cursor)
    }

    private func fetchActivities(type: String, cursor: String?) async -> UserPostPage {
        var queryItems = [URLQueryItem(name: "type", value: type)]
        if let cursor {
            queryItems.append(URLQueryItem(name: "cursor", value: cursor))
        }
        let endpoint = APIEndpoint(method: .get, path: "/users/me/activities", queryItems: queryItems, requiresAuth: true)
        guard let response: ActivityListResponseDTO = try? await apiClient.request(endpoint) else {
            return UserPostPage(items: [], nextCursor: nil, hasNext: false)
        }
        return UserPostPage(items: response.content.map(Self.toDomain), nextCursor: response.nextCursor, hasNext: response.hasNext)
    }

    // "내가 올린/투표한/작성한 글" 목록이라 서버가 작성자 정보를 따로 안 준다(항상 본인 글이라
    // 자명해서, API_SPEC 기준) — authorNickname/authorLevel은 nil로 두고, 화면 쪽에서 작성자
    // 정보를 아예 표시하지 않는다. activityAt이 없으면(=/users/me/posts/recent) createdAt을 쓴다.
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
            createdAt: dto.activityAt ?? dto.createdAt
        )
    }
}
