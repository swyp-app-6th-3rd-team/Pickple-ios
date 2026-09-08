//
//  RemoteGradeRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/8/26.
//

import Foundation

struct GradeCriteriaDTO: Decodable {
    let level: Int
    let name: String
    let requiredPoint: Int
    let requiredVoteCount: Int
}

struct RemoteGradeRepository: GradeRepository {
    let apiClient: APIClientProtocol

    func fetchGrades() async throws -> [GradeCriteria] {
        let endpoint = APIEndpoint(method: .get, path: "/grades", requiresAuth: false)
        let dtos: [GradeCriteriaDTO] = try await apiClient.request(endpoint)
        return dtos.map {
            GradeCriteria(level: $0.level, name: $0.name, requiredPoint: $0.requiredPoint, requiredVoteCount: $0.requiredVoteCount)
        }
    }
}
