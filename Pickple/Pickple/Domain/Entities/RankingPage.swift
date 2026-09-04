//
//  RankingPage.swift
//  Pickple
//
//  Created by 박윤수 on 9/5/26.
//

import Foundation

// GET /rankings의 무한 스크롤 한 조각. nextCursor가 nil이면 마지막 조각이다.
struct RankingPage {
    let items: [PickerRanking]
    let nextCursor: String?
}
