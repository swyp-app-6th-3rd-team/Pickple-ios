//
//  MyBadgeStrings.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import Foundation

enum MyBadgeStrings {
    static let title = "나의 뱃지"
    static let collectionStatus = "뱃지 수집 현황"
    static let confirm = "확인"
    static let newlyUnlockedTitle = "새로운 뱃지가 해제됐어요!"

    static func collectedCount(_ count: Int) -> String {
        "총 \(count)개 모았어요"
    }
}
