//
//  AppDeleteAccountEnvironment.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import SwiftUI

// PickpleApp이 들고 있는 탈퇴 동작을, 화면 계층을 거치지 않고 하위 뷰(MyAccountView 등)에 전달하기 위한 Environment 값.
// 실패(예: Apple 일시 장애로 인한 503)하면 로컬 상태를 건드리지 않고 그대로 에러를 던진다 — 재시도 가능해야 해서.
private struct AppDeleteAccountKey: EnvironmentKey {
    static let defaultValue: () async throws -> Void = {}
}

extension EnvironmentValues {
    var appDeleteAccount: () async throws -> Void {
        get { self[AppDeleteAccountKey.self] }
        set { self[AppDeleteAccountKey.self] = newValue }
    }
}
