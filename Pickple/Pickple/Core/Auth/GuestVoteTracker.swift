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
@Observable
class GuestVoteTracker {
    private(set) var count = 0
    static let limit = 3

    // 이번 투표를 게스트 무료 투표로 허용할 수 있으면 카운트를 올리고 true를 돌려준다.
    // 이미 한도를 다 썼으면 카운트를 올리지 않고 false를 돌려준다.
    func registerVote() -> Bool {
        guard count < Self.limit else { return false }
        count += 1
        return true
    }
}
