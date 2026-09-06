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

    func loadCards() async {
        allCards = (try? await voteCardRepository.fetchCards()) ?? []
    }

    // 홈 화면 상단 찬반/AB 탭 전환 시, 해당 유형의 카드만 다시 스와이프 스택으로 채운다.
    func filterCards(by type: VoteType) {
        voteCardData = allCards.filter { $0.type == type }
    }

    func vote(cardID: Int, side: VoteCardSide) {
        guard let index = voteCardData.firstIndex(where: { $0.id == cardID }), !voteCardData[index].isVoted else { return }

        if !isLoggedIn {
            guard guestVoteCount < Self.guestVoteLimit else {
                showsLoginRequired = true
                return
            }
            guestVoteCount += 1
        }

        // TODO: 실제 투표 API 연동 필요 — 지금은 로컬에서 선택한 쪽이 우세하도록 임의 비율로 채움
        let firstPercentage = side == .first ? Int.random(in: 55...80) : Int.random(in: 20...45)
        voteCardData[index].firstPercentage = firstPercentage
        voteCardData[index].secondPercentage = 100 - firstPercentage
    }

    func removeTopCard() {
        guard !voteCardData.isEmpty else { return }
        voteCardData.removeFirst()
    }
}
