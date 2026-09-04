//
//  Router.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//
//  탭별 네비게이션 경로의 공통 뼈대. 탭마다 Route enum만 다르고 나머지 동작은
//  동일해서(path 배열 + push), MainRouter/CommunityRouter/MyPageRouter가
//  각자 반복해서 구현하던 걸 여기로 모았다.

import SwiftUI

@Observable
class Router<Route: Hashable> {
    var path: [Route] = []

    func push(_ route: Route) {
        path.append(route)
    }
}
