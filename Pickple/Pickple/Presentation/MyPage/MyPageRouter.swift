//
//  MyPageRouter.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//
//  마이페이지 탭 전용 네비게이션 경로. route → 실제 화면 매핑은
//  PickpleBottomNav의 NavigationStack에 붙는다.

import SwiftUI

enum MyPageRoute: Hashable {
    case grade
    case badge
    case account
    case activity
    case postDetail(VoteType)
}

final class MyPageRouter: Router<MyPageRoute> {}
