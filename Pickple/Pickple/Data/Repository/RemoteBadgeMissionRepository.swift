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
            BadgeMissionProgress(
                id: UUID(),
                title: $0.description,
                badgeIconOffName: Self.badgeIconOffName(forMissionCode: $0.code),
                current: $0.current,
                target: $0.goal
            )
        }
    }

    // code는 API 문서가 "안정 식별자"라고 부르는 값인데, 문서 예시에 나온 건
    // "TOTAL_VOTE_10" 하나뿐이다. 나머지는 Mock 데이터의 임계값(10/100/500/1000, 20/30, 7/30일)과
    // 같은 네이밍 규칙일 거라 추정해서 채운 것 — 실제 로그인 응답으로 나머지 code 값을 받아보고
    // 다시 확인 필요.
    static func badgeIconOffName(forMissionCode code: String) -> String {
        switch code {
        case "TOTAL_VOTE_10": return "PickpleBadgeFirstPickOff"
        case "TOTAL_VOTE_100": return "PickpleBadgeSproutOff"
        case "TOTAL_VOTE_500": return "PickpleBadgeProOff"
        case "TOTAL_VOTE_1000": return "PickpleBadgeMasterOff"
        case "DAILY_VOTE_20": return "PickpleBadgeHunterOff"
        case "DAILY_VOTE_30": return "PickpleBadgeRampageOff"
        case "STREAK_7": return "PickpleBadgeAttendanceOff"
        case "STREAK_30": return "PickpleBadgeAddictOff"
        default: return "PickpleBadgeFirstPickOff" // 확인 안 된 code — 임시 기본값
        }
    }
}
