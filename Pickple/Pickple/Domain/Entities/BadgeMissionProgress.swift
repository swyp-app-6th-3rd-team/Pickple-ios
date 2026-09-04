//
//  BadgeMissionProgress.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Foundation

// 홈 화면 뱃지 획득 미션 드롭다운에 표시되는, 아직 해제하지 못한 미션 1개(그룹당 가장 낮은 단계).
// 나의 뱃지(MyBadge) 목록의 해당 뱃지와 1:1로 대응한다.
struct BadgeMissionProgress: Identifiable {
    let id: UUID
    let title: String       // "누적 투표 1,000회 달성" 등
    let badgeIconOffName: String  // 대응하는 MyBadge의 잠금 상태 아이콘
    let current: Int
    let target: Int
}
