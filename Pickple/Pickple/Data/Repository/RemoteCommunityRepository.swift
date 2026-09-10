//
//  RemoteCommunityRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/5/26.
//

import Foundation

struct PostListItemDTO: Decodable {
    let id: Int
    let type: String
    let category: String
    let title: String
    let description: String?
    let commentCount: Int
    let voteCount: Int?
    let thumbnailUrl: String?
    let createdAt: Date
    let authorId: Int
    let authorNickname: String
    let authorRanking: Int?
}

struct PostScrollDTO: Decodable {
    let content: [PostListItemDTO]
    let nextCursor: String?
    let hasNext: Bool
}

struct RemoteCommunityRepository: CommunityRepository {
    let apiClient: APIClientProtocol

    func fetchPosts(category: String?, cursor: String?) async throws -> PostPage {
        var queryItems: [URLQueryItem] = []
        if let category {
            queryItems.append(URLQueryItem(name: "category", value: category))
        }
        if let cursor {
            queryItems.append(URLQueryItem(name: "cursor", value: cursor))
        }
        let endpoint = APIEndpoint(method: .get, path: "/posts", queryItems: queryItems, requiresAuth: false)
        let dto: PostScrollDTO = try await apiClient.request(endpoint)
        return PostPage(items: dto.content.map(Self.toDomain), nextCursor: dto.nextCursor, hasNext: dto.hasNext)
    }

    func fetchPopularPosts() async throws -> [PostSummary] {
        let endpoint = APIEndpoint(method: .get, path: "/posts/popular", requiresAuth: false)
        let dtos: [PostListItemDTO] = try await apiClient.request(endpoint)
        return dtos.map(Self.toDomain)
    }

    // TODO: 게시글 목록 응답에 작성자 등급(1~5)이 없어서(authorRanking은 전체 순위라 별개 개념)
    // authorLevel은 1로 고정한다 — RemotePickerRankingRepository와 동일한 임시 처리.
    static func toDomain(_ dto: PostListItemDTO) -> PostSummary {
        .fromServerFields(
            id: dto.id,
            type: dto.type,
            category: dto.category,
            title: dto.title,
            description: dto.description,
            thumbnailUrl: dto.thumbnailUrl,
            voteCount: dto.voteCount,
            commentCount: dto.commentCount,
            createdAt: dto.createdAt,
            authorNickname: dto.authorNickname,
            authorLevel: 1
        )
    }
}
