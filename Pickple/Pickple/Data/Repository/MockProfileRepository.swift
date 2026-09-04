//
//  MockProfileRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import Foundation

struct MockProfileRepository: ProfileRepository {
    func fetchMyProfile() async throws -> UserProfile {
        UserProfile(userId: 0, nickname: nil, profileImageUrl: nil)
    }

    func checkNicknameAvailability(_ nickname: String) async throws -> NicknameAvailability {
        NicknameAvailability(isAvailable: true, message: "사용 가능한 닉네임")
    }

    func registerProfile(nickname: String) async throws {}
}
