//
//  ProfileRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

protocol ProfileRepository {
    func fetchMyProfile() async throws -> UserProfile
    func registerProfile(nickname: String) async throws
}
