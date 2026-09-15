//
//  ProfileRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import UIKit

protocol ProfileRepository {
    func fetchMyProfile() async throws -> UserProfile
    func checkNicknameAvailability(_ nickname: String) async throws -> NicknameAvailability
    // PROFILE 용도로 이미지 한 장을 업로드하고 accessUrl을 돌려준다. registerProfile/updateProfile의
    // profileImageUrl에 그대로 넣어 쓴다(API_SPEC 기준 — 업로드 응답 그대로, 대소문자도 바꾸지 않음).
    func uploadProfileImage(_ image: UIImage) async throws -> String
    // profileImageUrl이 nil이면 서버는 기존 사진을 유지한다(현재 사진이 없을 때만 기본 이미지로 채움).
    func registerProfile(nickname: String, profileImageUrl: String?) async throws
    func updateProfile(nickname: String, profileImageUrl: String?) async throws
}
