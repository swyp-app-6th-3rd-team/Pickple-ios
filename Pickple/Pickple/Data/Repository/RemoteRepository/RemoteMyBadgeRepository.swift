//
//  RemoteMyBadgeRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import Foundation

struct BadgeCollectionDTO: Decodable {
    let collectedCount: Int
    let badges: [BadgeDTO]
}

struct BadgeDTO: Decodable {
    let code: String
    let name: String
    let description: String
    let conditionType: String
    let threshold: Int
    let acquired: Bool
}

struct RemoteMyBadgeRepository: MyBadgeRepository {
    let apiClient: APIClientProtocol

    func fetchMyBadges() async throws -> [MyBadge] {
        let endpoint = APIEndpoint(method: .get, path: "/users/me/badges", requiresAuth: true)
        let dto: BadgeCollectionDTO = try await apiClient.request(endpoint)
        return dto.badges.map {
            let iconFamily = BadgeIconFamily.forCode($0.code)
            return MyBadge(
                id: UUID(),
                code: $0.code,
                title: $0.name,
                iconOnName: iconFamily.onIconName,
                iconOffName: iconFamily.offIconName,
                isUnlocked: $0.acquired,
                unlockCondition: "이 뱃지를 해제하려면\n\($0.description) 달성하세요."
            )
        }
    }
}
