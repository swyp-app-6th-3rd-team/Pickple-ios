//
//  AppLogoutEnvironment.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import SwiftUI

// PickpleApp이 들고 있는 로그아웃 동작을, 화면 계층을 거치지 않고 하위 뷰(MyAccountView 등)에 전달하기 위한 Environment 값.
private struct AppLogoutKey: EnvironmentKey {
    static let defaultValue: () async -> Void = {}
}

extension EnvironmentValues {
    var appLogout: () async -> Void {
        get { self[AppLogoutKey.self] }
        set { self[AppLogoutKey.self] = newValue }
    }
}
