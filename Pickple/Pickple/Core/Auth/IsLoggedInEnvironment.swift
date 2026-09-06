//
//  IsLoggedInEnvironment.swift
//  Pickple
//
//  Created by 박윤수 on 9/6/26.
//

import SwiftUI

// 게스트(SessionState.guest)와 완전 로그인(SessionState.loggedIn)을 하위 화면들이 구분할 수 있도록
// PickpleApp이 내려보내는 실제 인증 여부. 기본값은 게스트/미로그인 취급이 안전한 쪽인 false다.
private struct IsLoggedInKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var isLoggedIn: Bool {
        get { self[IsLoggedInKey.self] }
        set { self[IsLoggedInKey.self] = newValue }
    }
}
