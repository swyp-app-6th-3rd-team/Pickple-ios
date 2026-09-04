//
//  RemoteProfileRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import Foundation

struct UserProfileDTO: Decodable {
    let userId: Int
    let nickname: String?
    let profileImageUrl: String?
}

struct ProfileRequestDTO: Encodable {
    let nickname: String
    let profileImageUrl: String?
}

struct RemoteProfileRepository: ProfileRepository {
    let apiClient: APIClientProtocol

    func fetchMyProfile() async throws -> UserProfile {
        let endpoint = APIEndpoint(method: .get, path: "/users/me", requiresAuth: true)
        let dto: UserProfileDTO = try await apiClient.request(endpoint)
        return UserProfile(userId: dto.userId, nickname: dto.nickname, profileImageUrl: dto.profileImageUrl)
    }

    // 이미지 업로드 엔드포인트가 아직 없어서 profileImageUrl은 항상 nil로 보낸다 —
    // 서버가 안 주면 기본 이미지를 채워준다(API_SPEC 기준). 업로드 붙으면 여기 확장.
    func registerProfile(nickname: String) async throws {
        let body = try JSONEncoder().encode(ProfileRequestDTO(nickname: nickname, profileImageUrl: nil))
        let endpoint = APIEndpoint(method: .post, path: "/users/profile", body: body, requiresAuth: true)
        try await apiClient.requestVoid(endpoint)
    }
}
