//
//  PickerRanking.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Foundation

struct PickerRanking: Identifiable {
    let id: UUID
    let rank: Int
    let nickname: String
    let level: Int                       // 등급명칭/뱃지 매핑용(PickpleLevelBadge1~5)
    let profileImageName: String?
    let points: Int

    //추후 API 스펙에 맞게 수정
}
