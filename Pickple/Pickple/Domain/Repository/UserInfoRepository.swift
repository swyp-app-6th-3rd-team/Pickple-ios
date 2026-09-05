//
//  UserInfoRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//

protocol UserInfoRepository {
    func fetchUserInfo() async throws -> UserInfo
}
