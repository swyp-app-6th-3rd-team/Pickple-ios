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
            MyBadge(
                id: UUID(),
                title: $0.name,
                iconOnName: Self.iconOnName(forBadgeCode: $0.code),
                iconOffName: RemoteBadgeMissionRepository.badgeIconOffName(forMissionCode: $0.code),
                isUnlocked: $0.acquired,
                // 서버가 "방금 해금됨" 여부를 따로 안 줘서, 지금은 항상 false로 둔다.
                // 축하 모달을 계속 쓰려면 서버에 플래그 추가를 요청하거나 클라이언트가 마지막 확인 시점을
                // 저장해서 직접 비교해야 한다 — 이번 라운드 범위 밖.
                isNewlyUnlocked: false,
                unlockCondition: "이 뱃지를 해제하려면\n\($0.description) 달성하세요."
            )
        }
    }

    // 뱃지 코드 → 해금 상태 아이콘. Off 아이콘과 같은 code 규칙 추정을 그대로 쓴다.
    static func iconOnName(forBadgeCode code: String) -> String {
        switch code {
        case "TOTAL_VOTE_10": return "PickpleBadgeFirstPickOn"
        case "TOTAL_VOTE_100": return "PickpleBadgeSproutOn"
        case "TOTAL_VOTE_500": return "PickpleBadgeProOn"
        case "TOTAL_VOTE_1000": return "PickpleBadgeMasterOn"
        case "DAILY_VOTE_20": return "PickpleBadgeHunterOn"
        case "DAILY_VOTE_30": return "PickpleBadgeRampageOn"
        case "STREAK_7": return "PickpleBadgeAttendanceOn"
        case "STREAK_30": return "PickpleBadgeAddictOn"
        default: return "PickpleBadgeFirstPickOn" // 확인 안 된 code — 임시 기본값
        }
    }
}
