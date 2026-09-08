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

    static func requirementDescription(point: Int, voteCount: Int) -> String {
        guard point > 0 || voteCount > 0 else { return "가입 시 기본 부여 0P" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let pointText = formatter.string(from: NSNumber(value: point)) ?? "\(point)"
        let voteCountText = formatter.string(from: NSNumber(value: voteCount)) ?? "\(voteCount)"
        return "누적 \(pointText)P + 투표 \(voteCountText)회"
    }
}
