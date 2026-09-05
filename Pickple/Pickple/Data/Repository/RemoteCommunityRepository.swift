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

    func fetchPosts() async throws -> [PostSummary] {
        let endpoint = APIEndpoint(method: .get, path: "/posts", requiresAuth: false)
        let dto: PostScrollDTO = try await apiClient.request(endpoint)
        return dto.content.map(Self.toDomain)
    }

    func fetchPopularPosts() async throws -> [PostSummary] {
        let endpoint = APIEndpoint(method: .get, path: "/posts/popular", requiresAuth: false)
        let dtos: [PostListItemDTO] = try await apiClient.request(endpoint)
        return dtos.map(Self.toDomain)
    }

    // TODO: 게시글 목록 응답에 작성자 등급(1~5)이 없어서(authorRanking은 전체 순위라 별개 개념)
    // authorLevel은 1로 고정한다 — RemotePickerRankingRepository와 동일한 임시 처리.
    static func toDomain(_ dto: PostListItemDTO) -> PostSummary {
        PostSummary(
            id: dto.id,
            type: VoteType(serverType: dto.type),
            category: dto.category,
            title: dto.title,
            description: dto.description ?? "",
            thumbnailUrl: dto.thumbnailUrl.flatMap(URL.init(string:)),
            authorNickname: dto.authorNickname,
            authorLevel: 1,
            authorProfileImageUrl: nil,
            voteCount: dto.voteCount ?? 0,
            commentCount: dto.commentCount,
            createdAt: dto.createdAt
        )
    }
}
