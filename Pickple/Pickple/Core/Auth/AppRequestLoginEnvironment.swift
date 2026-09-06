//
//  AppRequestLoginEnvironment.swift
//  Pickple
//
//  Created by 박윤수 on 9/6/26.
//

import SwiftUI

// 게스트/미로그인 상태에서 뜨는 "로그인 유도" 모달의 확정 동작 — 화면 계층을 거치지 않고
// 하위 뷰(CommunityView, MainView, PostDetailView 등)에서 로그인 화면으로 돌아가도록 요청할 때 쓴다.
private struct AppRequestLoginKey: EnvironmentKey {
    static let defaultValue: () -> Void = {}
}

extension EnvironmentValues {
    var appRequestLogin: () -> Void {
        get { self[AppRequestLoginKey.self] }
        set { self[AppRequestLoginKey.self] = newValue }
    }
}
