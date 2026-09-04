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

struct NicknameAvailabilityDTO: Decodable {
    let available: Bool
    let message: String
}

struct RemoteProfileRepository: ProfileRepository {
    let apiClient: APIClientProtocol

    func fetchMyProfile() async throws -> UserProfile {
        let endpoint = APIEndpoint(method: .get, path: "/users/me", requiresAuth: true)
        let dto: UserProfileDTO = try await apiClient.request(endpoint)
        return UserProfile(userId: dto.userId, nickname: dto.nickname, profileImageUrl: dto.profileImageUrl)
    }

    func checkNicknameAvailability(_ nickname: String) async throws -> NicknameAvailability {
        let endpoint = APIEndpoint(
            method: .get,
            path: "/users/nickname/availability",
            queryItems: [URLQueryItem(name: "value", value: nickname)],
            requiresAuth: false
        )
        let dto: NicknameAvailabilityDTO = try await apiClient.request(endpoint)
        return NicknameAvailability(isAvailable: dto.available, message: dto.message)
    }

    // 이미지 업로드(POST /images)는 attachType이 PRODUCT/COMMENT만 있고 PROFILE이 없어서
    // 프로필 사진 용도로 써도 되는지 확인 안 됨 — 그래서 profileImageUrl은 항상 nil로 보낸다.
    // 서버가 안 주면 기본 이미지를 채워준다(API_SPEC 기준). 용도 확인되면 여기 확장.
    func registerProfile(nickname: String) async throws {
        let body = try JSONEncoder().encode(ProfileRequestDTO(nickname: nickname, profileImageUrl: nil))
        let endpoint = APIEndpoint(method: .post, path: "/users/profile", body: body, requiresAuth: true)
        try await apiClient.requestVoid(endpoint)
    }
}
