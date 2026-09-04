//
//  APIClientEnvironment.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import SwiftUI

// 화면 계층 깊숙한 곳(PickpleBottomNav 하위 탭들)에서 각자의 Repository를 만들 때
// APIClient를 매번 새로 생성자 인자로 뚫어 내려보내지 않도록 Environment로 전달한다.
// 기본값은 로그인 전/프리뷰에서 실수로 쓰였을 때 바로 티가 나도록 인증이 항상 실패하는 빈 토큰 저장소를 물린다.
private struct APIClientKey: EnvironmentKey {
    static let defaultValue: APIClientProtocol = APIClient(
        baseURL: APIEnvironment.devBaseURL,
        tokenProvider: InMemoryTokenStore()
    )
}

extension EnvironmentValues {
    var apiClient: APIClientProtocol {
        get { self[APIClientKey.self] }
        set { self[APIClientKey.self] = newValue }
    }
}
