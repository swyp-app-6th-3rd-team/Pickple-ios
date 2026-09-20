//
//  MyBadge.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Foundation

struct MyBadge: Identifiable {
    let id: UUID
    // 서버가 주는 안정적인 뱃지 식별자 — id(UUID)는 매 조회마다 새로 생성돼 기기에 저장해둘
    // 키로 못 쓴다. "방금 해금된 뱃지"를 기억하려면 이 code로 비교한다.
    let code: String
    let title: String           // "첫 PICK"
    let iconOnName: String      // 해금 상태 아이콘
    let iconOffName: String     // 잠금 상태 아이콘
    let isUnlocked: Bool
    let unlockCondition: String // 서버 description 그대로. 예: "누적 투표 10회"

    //추후 API 스펙에 맞게 수정
}
