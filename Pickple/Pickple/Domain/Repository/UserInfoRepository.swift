//
//  UserInfoRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//

protocol UserInfoRepository {
    func fetchUserProfile() async -> UserInfo
    //실제 API와 연동
}
