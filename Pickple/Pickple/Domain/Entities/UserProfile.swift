//
//  UserProfile.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import Foundation

struct UserProfile {
    let userId: Int
    // 프로필 등록 전이면 nil — 로그인 직후 프로필 설정 화면으로 보낼지 판단하는 기준이다.
    let nickname: String?
    let profileImageUrl: String?
}
