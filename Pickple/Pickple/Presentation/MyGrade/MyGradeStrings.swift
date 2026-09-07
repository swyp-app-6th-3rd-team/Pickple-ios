//
//  MyGradeStrings.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import Foundation

enum MyGradeStrings {
    static let title = "나의 등급"
    static let voteCountPrefix = "투표"
    static let voteCountSuffix = "회"

    // TODO: 스크린샷 기준 하드코딩 — 실제 등급 정책 확정 필요
    static let gradeDescriptions: [Int: String] = [
        1: "가입 시 기본 부여 0P",
        2: "누적 200P + 투표 20회",
        3: "누적 1,000P + 투표 100회",
        4: "누적 3,500P + 투표 300회",
        5: "누적 10,000P + 투표 1,000회",
    ]
}
