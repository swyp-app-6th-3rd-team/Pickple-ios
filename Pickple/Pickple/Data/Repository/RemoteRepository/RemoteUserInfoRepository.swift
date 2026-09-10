//
//  RemoteUserInfoRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/5/26.
//

import Foundation

struct UserPointsDTO: Decodable {
    let userId: Int
    let nickname: String?
    let profileImageUrl: String?
    let ranking: Int?
    let point: Int
}

struct NextGradeDTO: Decodable {
    let level: Int
    let name: String
    let requiredPoint: Int
    let requiredVoteCount: Int
}

struct UserGradeDTO: Decodable {
    let level: Int
    let name: String
    let point: Int
    let voteCount: Int
    let nextGrade: NextGradeDTO?
    let achievementRate: Int
}

struct ActivitySummaryDTO: Decodable {
    let voteCount: Int
    let commentCount: Int
    let postCount: Int
}

// 단일 엔드포인트가 아니라 포인트/등급/활동 요약 3개를 조합해서 하나의 UserInfo로 합친다.
// 한 곳이 실패해도 나머지로 화면을 최대한 채우기보다는, 셋 다 있어야 의미가 있는
// 값들이라 하나라도 실패하면 전체를 실패로 처리한다.
struct RemoteUserInfoRepository: UserInfoRepository {
    let apiClient: APIClientProtocol

    func fetchUserInfo() async throws -> UserInfo {
        let pointsDTO: UserPointsDTO = try await apiClient.request(
            APIEndpoint(method: .get, path: "/users/me/points", requiresAuth: true)
        )
        let gradeDTO: UserGradeDTO = try await apiClient.request(
            APIEndpoint(method: .get, path: "/users/me/grade", requiresAuth: true)
        )
        let summaryDTO: ActivitySummaryDTO = try await apiClient.request(
            APIEndpoint(method: .get, path: "/users/me/activities/summary", requiresAuth: true)
        )

        let pointsToNextLevel = gradeDTO.nextGrade.map { max(0, $0.requiredPoint - gradeDTO.point) } ?? 0

        return UserInfo(
            id: UUID(),
            nickname: pointsDTO.nickname ?? "",
            profileImageUrl: pointsDTO.profileImageUrl.flatMap(URL.init(string:)),
            voteCount: summaryDTO.voteCount,
            commentCount: summaryDTO.commentCount,
            postCount: summaryDTO.postCount,
            points: gradeDTO.point,
            level: gradeDTO.level,
            pointsToNextLevel: pointsToNextLevel
        )
    }
}
