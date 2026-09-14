//
//  RemoteProfileRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import Foundation
import UIKit

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

private struct ProfileImageUploadResponseDTO: Decodable {
    struct Image: Decodable {
        let accessUrl: String?
    }
    let images: [Image]?
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

    // POST /images?attachType=PROFILE — JPEG·PNG만, 파일당 5MB, PROFILE은 정확히 1장(API_SPEC 기준).
    // 프로필 사진은 대부분 카메라/앨범 사진(연속톤)이라 PNG보다 JPEG가 훨씬 작아 JPEG로 변환한다.
    func uploadProfileImage(_ image: UIImage) async throws -> String {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw APIError.decoding("이미지를 JPEG로 변환할 수 없습니다")
        }
        let file = MultipartFile(fieldName: "images", filename: "profile.jpg", mimeType: "image/jpeg", data: data)
        let endpoint = APIEndpoint(
            method: .post,
            path: "/images",
            queryItems: [URLQueryItem(name: "attachType", value: "PROFILE")],
            multipartFiles: [file],
            requiresAuth: true
        )
        let response: ProfileImageUploadResponseDTO = try await apiClient.request(endpoint)
        guard let accessUrl = response.images?.first?.accessUrl else {
            throw APIError.decoding("업로드 응답에 accessUrl이 없습니다")
        }
        return accessUrl
    }

    // 등록/수정은 HTTP 메서드(POST/PATCH)만 다르고 나머지는 동일해서 공용으로 뺐다.
    // profileImageUrl을 nil로 보내면 서버가 기존 사진을 유지한다(API_SPEC 기준 — 생략/null/빈 문자열 동일 취급).
    func registerProfile(nickname: String, profileImageUrl: String?) async throws {
        try await saveProfile(nickname: nickname, profileImageUrl: profileImageUrl, method: .post)
    }

    func updateProfile(nickname: String, profileImageUrl: String?) async throws {
        try await saveProfile(nickname: nickname, profileImageUrl: profileImageUrl, method: .patch)
    }

    private func saveProfile(nickname: String, profileImageUrl: String?, method: HTTPMethod) async throws {
        let body = try JSONEncoder().encode(ProfileRequestDTO(nickname: nickname, profileImageUrl: profileImageUrl))
        let endpoint = APIEndpoint(method: method, path: "/users/profile", body: body, requiresAuth: true)
        try await apiClient.requestVoid(endpoint)
    }
}
