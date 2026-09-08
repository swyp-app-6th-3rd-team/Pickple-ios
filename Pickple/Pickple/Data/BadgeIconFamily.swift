//
//  BadgeIconFamily.swift
//  Pickple
//
//  Created by 박윤수 on 9/5/26.
//

import Foundation

// 뱃지 미션 API(/users/me/badges/missions)와 뱃지 현황 API(/users/me/badges)가
// 공통으로 내려주는 code("안정 식별자") → 아이콘 에셋 매핑. 두 API가 각각
// Off/On 아이콘만 다르게 쓸 뿐 같은 code 규칙을 공유해서 한 곳에 모아둔다.
//
// code는 API 문서에 확인된 예시가 "TOTAL_VOTE_10" 하나뿐이라, 나머지는 Mock 데이터의
// 임계값(10/100/500/1000회, 일 20/30회, 7/30일 연속)과 같은 네이밍 규칙일 거라 추정한 것 —
// 실제 로그인 응답으로 나머지 code 값을 받아보고 다시 확인 필요.
enum BadgeIconFamily: String {
    case firstPick = "FirstPick"
    case sprout = "Sprout"
    case pro = "Pro"
    case master = "Master"
    case hunter = "Hunter"
    case rampage = "Rampage"
    case attendance = "Attendance"
    case addict = "Addict"

    static func forCode(_ code: String) -> BadgeIconFamily {
        switch code {
        case "TOTAL_VOTE_10": return .firstPick
        case "TOTAL_VOTE_100": return .sprout
        case "TOTAL_VOTE_500": return .pro
        case "TOTAL_VOTE_1000": return .master
        case "DAILY_VOTE_20": return .hunter
        case "DAILY_VOTE_30": return .rampage
        case "STREAK_7": return .attendance
        case "STREAK_30": return .addict
        default: return .firstPick // 확인 안 된 code — 임시 기본값
        }
    }

    var offIconName: String { "PickpleBadge\(rawValue)Off" }
    var onIconName: String { "PickpleBadge\(rawValue)On" }

    // "N일 연속" 진행도 바(BadgeMissionStreakTracker)를 보여줄 대상인지.
    // description 문자열에 "연속"이 포함되는지로 판별하던 이전 로직은 실제 서버 문구가
    // 달라서 안 걸렸던 버그가 있어, 이미 안정 식별자로 쓰고 있는 code(→ family) 기준으로 바꿨다.
    var isStreakType: Bool {
        self == .attendance || self == .addict
    }
}
