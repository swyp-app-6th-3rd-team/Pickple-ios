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
// code 네이밍 규칙은 실제 로그인 응답으로 "TOTAL_VOTE_10"·"DAILY_VOTE_20" 두 개가
// {conditionType}_{임계값} 패턴과 정확히 일치하는 걸 확인했다(2026-09-10). STREAK_7/30은
// 이 계정이 아직 그 단계(일일투표 20·30개를 먼저 다 채워야 미션 2 사다리에서 그다음
// 순서로 나타남 — 기능명세서 "미션 2" 참고)에 도달하지 않아서 실제 값을 직접 보지는
// 못했지만, 같은 패턴일 거라 추정해서 둔다.
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
        default:
            // 정확한 임계값 접미사(_7/_30)까지는 못 맞혀도, code가 STREAK로 시작하면 최소한
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
