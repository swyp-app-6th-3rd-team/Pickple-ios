//
//  RemoteBadgeMissionRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import Foundation

struct MissionDTO: Decodable {
    let code: String
    let description: String
    let conditionType: String
    let current: Int
    let goal: Int
}

struct RemoteBadgeMissionRepository: BadgeMissionRepository {
    let apiClient: APIClientProtocol

    func fetchInProgressMissions() async throws -> [BadgeMissionProgress] {
        let endpoint = APIEndpoint(method: .get, path: "/users/me/badges/missions", requiresAuth: true)
        let dtos: [MissionDTO] = try await apiClient.request(endpoint)
        return dtos.map {
            let family = BadgeIconFamily.forCode($0.code)
            return BadgeMissionProgress(
                id: UUID(),
                title: $0.description,
                badgeIconOffName: family.offIconName,
                iconFamily: family,
                current: $0.current,
                target: $0.goal
            )
        }
    }
}
