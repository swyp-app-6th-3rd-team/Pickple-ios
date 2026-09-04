//
//  MainRouter.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//
//  홈 탭 전용 네비게이션 경로. route → 실제 화면 매핑은
//  PickpleBottomNav의 NavigationStack에 붙는다.

import SwiftUI

enum MainRoute: Hashable {
    case postDetail(VoteType)
    case ranking
}

final class MainRouter: Router<MainRoute> {}
