//
//  AccessTokenProviding.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import Foundation

// APIClient가 인증이 필요한 요청에 Authorization 헤더를 채우기 위해 참조하는 토큰 출처.
protocol AccessTokenProviding: Sendable {
    func accessToken() async -> String?
}

// TODO: 실제로는 Keychain에 저장된 리프레시 토큰으로 갱신하는 로직 필요 (POST /auth/mobile/refresh 연동 후 대체)
// 지금은 메모리에만 들고 있는 임시 저장소
actor InMemoryTokenStore: AccessTokenProviding {
    private var token: String?

    func accessToken() async -> String? {
        token
    }

    func update(_ token: String?) {
        self.token = token
    }
}
