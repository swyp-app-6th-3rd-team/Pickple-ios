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
// code 네이밍 규칙은 {conditionType}_{임계값} 패턴 — 실제 로그인 응답으로 전부 확인 완료
// (2026-09-19). STREAK 계열은 conditionType이 "STREAK"가 아니라 "STREAK_VOTE"라 code가
// "STREAK_VOTE_7"/"STREAK_VOTE_30"으로 온다(추측했던 "STREAK_7"/"STREAK_30"과 다름 —
// 이 추측값 때문에 둘 다 default의 hasPrefix("STREAK")에 걸려 attendance로 뭉쳐 보이던
// 버그가 있었다).
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
        case "STREAK_VOTE_7": return .attendance
        case "STREAK_VOTE_30": return .addict
        default:
            // 정확한 임계값 접미사(_7/_30)까지는 못 맞혀도, code가 STREAK 계열이면 최소한
            // ladderPosition은 값이 나오도록 한다.
            return code.hasPrefix("STREAK") ? .attendance : .firstPick
        }
    }

    var offIconName: String { "PickpleBadge\(rawValue)Off" }
    var onIconName: String { "PickpleBadge\(rawValue)On" }

    // 이 계열(누적 또는 일일+연속) 안에서 지금 활성 단계가 몇 번째인지(1부터) — 그 계열에서
    // 이미 완료된 단계 수는 이 값 - 1이다. 두 계열이 나란히 4단계씩이라 위치가 그대로 대응된다.
    var ladderPosition: Int {
        switch self {
        case .firstPick, .hunter: return 1
        case .sprout, .rampage: return 2
        case .pro, .attendance: return 3
        case .master, .addict: return 4
        }
    }

    // 누적(미션 1) 계열인지, 일일투표+연속출석(미션 2) 계열인지.
    var isCumulativeFamily: Bool {
        switch self {
        case .firstPick, .sprout, .pro, .master: return true
        case .hunter, .rampage, .attendance, .addict: return false
        }
    }
}
