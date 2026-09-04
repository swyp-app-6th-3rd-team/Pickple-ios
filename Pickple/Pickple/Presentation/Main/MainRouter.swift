//
//  MainRouter.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//
//  홈 탭 전용 네비게이션 경로. MainView와 그 하위 뷰는 화면을 직접 그리지 않고
//  router.push(route)로 "어디로 갈지"만 알린다. route → 실제 화면 매핑은
//  PickpleBottomNav의 NavigationStack에 붙은 .navigationDestination(for:)가 담당한다.

import SwiftUI

enum MainRoute: Hashable {
    case postDetail(VoteType)
    case ranking
}

@Observable
final class MainRouter {
    var path: [MainRoute] = []

    func push(_ route: MainRoute) {
        path.append(route)
    }
}
