//
//  VoteCardRepository.swift
//  Pickple
//
//  Created by 박윤수 on 8/31/26.
//

protocol VoteCardRepository {
    // GET /posts/random은 type을 하나만 받는다(AGREE|A_B) — 찬반/AB 두 번 호출해서 합친다.
    func fetchCards(type: VoteType) async throws -> [VoteCard]
    // 선택지별 최신 득표율을 그대로 돌려준다. 로그인 사용자만 호출 가능(게스트는 토큰이 없어서
    // 서버에 실제로 투표할 방법이 없다 — 게스트 투표는 CardStackViewModel이 로컬로만 흉내낸다).
    func castVote(postId: Int, optionId: Int) async throws -> (firstPercentage: Int, secondPercentage: Int)
}
