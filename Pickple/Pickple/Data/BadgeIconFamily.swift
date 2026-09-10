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
            // isStreakType은 맞게 판정되도록 한다 — 그래야 진행도 바가 뜨는지 자체는 실제
            // 값과 무관하게 확인할 수 있다.
            return code.hasPrefix("STREAK") ? .attendance : .firstPick
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
