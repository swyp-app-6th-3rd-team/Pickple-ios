//
//  PostSortOrder.swift
//  Pickple
//
//  Created by 박윤수 on 9/5/26.
//

import Foundation

// "최신순/오래된 순" 정렬을 CommunityViewModel/PostDetailViewModel/MyActivityViewModel이
// 각자 switch/삼항연산자로 따로 구현하고 있던 걸 모았다. 화면마다 옵션 문자열(예: "최신순")은
// 그대로 자기 것을 쓰고, 실제 날짜 비교 알고리즘만 여기로 위임한다.
enum PostSortOrder {
    static func sorted<T>(_ items: [T], ascending: Bool, date: (T) -> Date) -> [T] {
        ascending
            ? items.sorted { date($0) < date($1) }
            : items.sorted { date($0) > date($1) }
    }
}
