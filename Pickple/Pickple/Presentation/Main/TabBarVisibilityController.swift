//
//  TabBarVisibilityController.swift
//  Pickple
//
//  Created by 박윤수 on 9/16/26.
//
//  홈/커뮤니티/마이페이지 각 화면이 자기 스크롤 위치를 보고 커스텀 하단 바를
//  숨길지 결정하는데, 그 결과를 PickpleBottomNav의 커스텀 바가 받아서 슬라이드
//  애니메이션을 그려야 해서 화면 트리를 넘나드는 공유 상태가 필요하다 — .environment로
//  주입해서 쓴다.

import SwiftUI

@Observable
final class TabBarVisibilityController {
    var isHidden = false
}
