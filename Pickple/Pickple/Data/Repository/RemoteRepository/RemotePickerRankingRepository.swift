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
    // 2026-09-13 신규. 저장된 값을 그대로 받는다(포인트로 재계산하지 않음, 등급은 안 내려감).
    let gradeLevel: Int?
    let gradeName: String?
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

    // GET /users/me/points — ranking이 null이면 아직 배치가 안 돈 것(가입 직후)이라 nil을 그대로 반환한다.
    func fetchMyRanking() async throws -> PickerRanking? {
        let endpoint = APIEndpoint(method: .get, path: "/users/me/points", requiresAuth: true)
        let dto: UserPointsDTO = try await apiClient.request(endpoint)
        guard let ranking = dto.ranking else { return nil }
        return PickerRanking(
            id: UUID(),
            rank: ranking,
            nickname: dto.nickname ?? "",
            level: dto.gradeLevel ?? 1,
            profileImageUrl: dto.profileImageUrl.flatMap(URL.init(string:)),
            points: dto.point
        )
    }

    private static func toDomain(_ dto: RankingItemDTO) -> PickerRanking {
        PickerRanking(
            id: UUID(),
            rank: dto.ranking,
            nickname: dto.nickname,
            level: dto.gradeLevel ?? 1,
            profileImageUrl: dto.profileImageUrl.flatMap(URL.init(string:)),
            points: dto.point
        )
    }
}
