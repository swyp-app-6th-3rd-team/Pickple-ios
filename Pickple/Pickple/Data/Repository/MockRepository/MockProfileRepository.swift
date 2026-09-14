//
//  MockProfileRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import Foundation
import UIKit

struct MockProfileRepository: ProfileRepository {
    func fetchMyProfile() async throws -> UserProfile {
        UserProfile(userId: 0, nickname: nil, profileImageUrl: nil)
    }

    func checkNicknameAvailability(_ nickname: String) async throws -> NicknameAvailability {
        NicknameAvailability(isAvailable: true, message: "사용 가능한 닉네임")
    }

    func uploadProfileImage(_ image: UIImage) async throws -> String {
        "https://mock.pickple.app/defaults/profile-1.png"
    }

    func registerProfile(nickname: String, profileImageUrl: String?) async throws {}

    func updateProfile(nickname: String, profileImageUrl: String?) async throws {}
}
