//
//  SessionTokenPersistence.swift
//  Pickple
//
//  Created by 박윤수 on 9/5/26.
//

import Foundation

// "로그인 토큰을 어디에 저장/삭제하는가"를 한 곳에 모은다. LoginViewModel(로그인 직후)과
// AppSessionViewModel(자동 로그인 복원/로그아웃/탈퇴) 양쪽에서 같은 두 줄이 따로 구현돼 있던 걸 정리했다.
enum SessionTokenPersistence {
    static func save(_ tokens: AuthTokens, tokenStore: InMemoryTokenStore, refreshTokenStore: RefreshTokenStoring) async throws {
        await tokenStore.update(tokens.accessToken)
        try refreshTokenStore.save(tokens.refreshToken)
    }

    static func clear(tokenStore: InMemoryTokenStore, refreshTokenStore: RefreshTokenStoring) async {
        refreshTokenStore.clear()
        await tokenStore.update(nil)
    }
}
