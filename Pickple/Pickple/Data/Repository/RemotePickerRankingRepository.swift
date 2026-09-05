//
//  RemotePickerRankingRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/5/26.
//

import Foundation

struct RankingItemDTO: Decodable {
    let userId: Int
    let nickname: String
    let profileImageUrl: String?
    let ranking: Int
    let point: Int
}

struct RankingScrollDTO: Decodable {
    let content: [RankingItemDTO]
    let nextCursor: String?
    let hasNext: Bool
}

struct RemotePickerRankingRepository: PickerRankingRepository {
    let apiClient: APIClientProtocol

    func fetchTopRankings() async throws -> [PickerRanking] {
        let endpoint = APIEndpoint(method: .get, path: "/rankings/top", requiresAuth: false)
        let dtos: [RankingItemDTO] = try await apiClient.request(endpoint)
        return dtos.map(Self.toDomain)
    }

    func fetchRankings(cursor: String?) async throws -> RankingPage {
        var queryItems: [URLQueryItem] = []
        if let cursor {
            queryItems.append(URLQueryItem(name: "cursor", value: cursor))
        }
        let endpoint = APIEndpoint(method: .get, path: "/rankings", queryItems: queryItems, requiresAuth: false)
        let dto: RankingScrollDTO = try await apiClient.request(endpoint)
        return RankingPage(items: dto.content.map(Self.toDomain), nextCursor: dto.nextCursor)
    }

    // TODO: RankingItem 응답에 등급/레벨 필드가 없어서(userId, nickname, profileImageUrl, ranking, point만 있음)
    // level은 1로 고정한다 — 확인되는 대로 실제 값으로 교체 필요.
    private static func toDomain(_ dto: RankingItemDTO) -> PickerRanking {
        PickerRanking(
            id: UUID(),
            rank: dto.ranking,
            nickname: dto.nickname,
            level: 1,
            profileImageName: dto.profileImageUrl,
            points: dto.point
        )
    }
}
