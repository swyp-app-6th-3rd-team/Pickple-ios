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
    case profile
    case grade
    case badge
    case account
    // initialTab — MyActivityView의 탭 인덱스(0=투표, 1=댓글, 2=작성글). 마이페이지 통계
    // 수치를 눌러서 들어갈 때 해당 탭이 바로 선택되어 있게 한다.
    case activity(initialTab: Int)
    case postDetail(postId: Int, type: VoteType)
}

final class MyPageRouter: Router<MyPageRoute> {}
