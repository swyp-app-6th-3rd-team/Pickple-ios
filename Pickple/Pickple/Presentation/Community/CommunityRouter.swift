//
//  CommunityRouter.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//
//  커뮤니티 탭 전용 네비게이션 경로. route → 실제 화면 매핑은
//  PickpleBottomNav의 NavigationStack에 붙는다.

import SwiftUI

enum CommunityRoute: Hashable {
    case postDetail(postId: Int, type: VoteType)
}

final class CommunityRouter: Router<CommunityRoute> {}
