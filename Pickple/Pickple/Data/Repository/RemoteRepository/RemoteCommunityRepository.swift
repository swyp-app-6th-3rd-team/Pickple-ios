//
//  RemoteCommunityRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/5/26.
//

import Foundation

// GET /posts/popular 전용 상품 사진. displayOrder 1=A(찬반은 유일한 상품), 2=B.
struct PostListProductDTO: Decodable {
    let displayOrder: Int
    let imageUrl: String?
}

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
    // GET /posts에만 있다(2026-09-15 신규). GET /posts/popular는 이 키가 없어 nil로 디코딩된다.
    let authorGradeLevel: Int?
    // products/commenterCount는 GET /posts/popular 전용. GET /posts는 이 키 자체가 없어서 자연히 nil로 디코딩된다.
    let products: [PostListProductDTO]?
    let commenterCount: Int?
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

    // authorRanking(전체 순위)과 authorGradeLevel(등급)은 별개 값이다(API_SPEC 기준). GET /posts/popular는
    // 이 필드가 아직 없어 dto.authorGradeLevel이 nil이므로, 기존과 동일하게 1로 폴백한다(회귀 없음).
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
            authorLevel: dto.authorGradeLevel ?? 1,
            products: (dto.products ?? []).map {
                PostSummaryProduct(displayOrder: $0.displayOrder, imageUrl: $0.imageUrl.flatMap(URL.init(string:)))
            },
            commenterCount: dto.commenterCount
        )
    }
}
