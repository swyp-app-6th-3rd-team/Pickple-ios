//
//  MyBadge.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Foundation

struct MyBadge: Identifiable {
    let id: UUID
    let title: String           // "첫 PICK"
    let iconOnName: String      // 해금 상태 아이콘
    let iconOffName: String     // 잠금 상태 아이콘
    let isUnlocked: Bool
    let unlockCondition: String // "이 뱃지를 해제하려면 누적 투표 10회를 달성하세요."

    //추후 API 스펙에 맞게 수정
}
