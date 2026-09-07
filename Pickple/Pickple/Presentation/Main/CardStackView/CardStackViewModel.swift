//
//  CardStackViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 8/31/26.
//
import Foundation

enum VoteCardSide {
    case first
    case second
}

@Observable
class CardStackViewModel {
    private var voteCardRepository: VoteCardRepository
    private var allCards: [VoteCard] = []

    var voteCardData: [VoteCard] = []
    var guestVoteCount = 0
    var showsLoginRequired = false

    private(set) var isLoggedIn: Bool
    static let guestVoteLimit = 3

    init(voteCardRepository: VoteCardRepository = MockVoteCardRepository(), isLoggedIn: Bool = true) {
        self.voteCardRepository = voteCardRepository
        self.isLoggedIn = isLoggedIn
    }

    // GET /posts/random은 type을 하나만 받아서, 찬반/AB를 각각 불러 합친다 —
    // 이후 탭 전환(filterCards)은 새 네트워크 호출 없이 이 합쳐둔 목록을 그냥 필터링만 한다.
    func loadCards() async {
        async let forAgainst = try? voteCardRepository.fetchCards(type: .forAgainst)
        async let ab = try? voteCardRepository.fetchCards(type: .ab)
        allCards = (await forAgainst ?? []) + (await ab ?? [])
    }

    // 홈 화면 상단 찬반/AB 탭 전환 시, 해당 유형의 카드만 다시 스와이프 스택으로 채운다.
    func filterCards(by type: VoteType) {
        voteCardData = allCards.filter { $0.type == type }
    }

    @MainActor
    func vote(cardID: Int, side: VoteCardSide) async {
        guard let index = voteCardData.firstIndex(where: { $0.id == cardID }), !voteCardData[index].isVoted else { return }

        if !isLoggedIn {
            guard guestVoteCount < Self.guestVoteLimit else {
                showsLoginRequired = true
                return
            }
            guestVoteCount += 1
            // 게스트는 토큰이 없어서 서버에 실제로 투표할 방법이 없다 — 로컬에서만 결과를 흉내낸다.
            let firstPercentage = side == .first ? Int.random(in: 55...80) : Int.random(in: 20...45)
            voteCardData[index].firstPercentage = firstPercentage
            voteCardData[index].secondPercentage = 100 - firstPercentage
            return
        }

        let card = voteCardData[index]
        guard let optionId = side == .first ? card.firstOptionId : card.secondOptionId else { return }

        guard let result = try? await voteCardRepository.castVote(postId: cardID, optionId: optionId) else { return }
        voteCardData[index].firstPercentage = result.firstPercentage
        voteCardData[index].secondPercentage = result.secondPercentage
    }

    func removeTopCard() {
        guard !voteCardData.isEmpty else { return }
        voteCardData.removeFirst()
    }
}
