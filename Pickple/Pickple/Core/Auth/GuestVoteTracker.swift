//
//  GuestVoteTracker.swift
//  Pickple
//
//  Created by 박윤수 on 9/8/26.
//

import Foundation

// 게스트의 무료 투표 3회는 화면(홈 카드스택/게시글 상세)과 무관하게 앱 전체에서 공유된다
// (기능명세서 2.2·6.3 모두 "게스트로 홈 화면 진입 → 투표 3번까지 허용"으로 동일하게 명시).
// PickpleApp이 하나만 만들어서 .environment로 내려보내고, 화면마다 각자 세는 게 아니라
// 이 인스턴스를 공유해서 카운트한다.
//
// 카운트를 UserDefaults에 저장해서 앱을 완전히 종료하고 재실행해도 유지되게 한다 — 메모리에만
// 있으면 앱을 껐다 켜는 것만으로 게스트가 매번 3회를 다시 받아가는 문제가 있었다. 서버가 아니라
// 클라이언트에만 저장하는 거라 앱 재설치·기기 초기화까지는 못 막는다 — 서버에서 추적할지는 별도 결정 필요.
@Observable
class GuestVoteTracker {
    private let userDefaults: UserDefaults
    private static let countKey = "guest.voteCount"
    static let limit = 3

    private(set) var count: Int

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.count = userDefaults.integer(forKey: Self.countKey)
    }

    // 이번 투표를 게스트 무료 투표로 허용할 수 있으면 카운트를 올리고 true를 돌려준다.
    // 이미 한도를 다 썼으면 카운트를 올리지 않고 false를 돌려준다.
    func registerVote() -> Bool {
        guard count < Self.limit else { return false }
        count += 1
        userDefaults.set(count, forKey: Self.countKey)
        return true
    }
}
