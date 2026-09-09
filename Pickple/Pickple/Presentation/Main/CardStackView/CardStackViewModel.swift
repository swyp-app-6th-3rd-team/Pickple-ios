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
    var showsLoginRequired = false

    private(set) var isLoggedIn: Bool
    // 게스트 무료 투표 3회는 이 화면(홈 카드스택) 전용이 아니라 게시글 상세 투표와 공유된다
    // (기능명세서 2.2·6.3 모두 동일한 "3번까지 허용" 문구) — 그래서 앱 전체에서 하나만
    // 만들어 공유하는 GuestVoteTracker를 주입받는다.
    private let guestVoteTracker: GuestVoteTracker

    init(
        voteCardRepository: VoteCardRepository = MockVoteCardRepository(),
        isLoggedIn: Bool = true,
        guestVoteTracker: GuestVoteTracker = GuestVoteTracker()
    ) {
        self.voteCardRepository = voteCardRepository
        self.isLoggedIn = isLoggedIn
        self.guestVoteTracker = guestVoteTracker
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
            guard guestVoteTracker.registerVote() else {
                showsLoginRequired = true
                return
            }
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

    // 카드를 배열에서 제거하지 않고 맨 뒤로 옮겨서, 다 넘기면 처음 카드부터 다시 무한으로 순환한다.
    func moveTopCardToBack() {
        guard !voteCardData.isEmpty else { return }
        let card = voteCardData.removeFirst()
        voteCardData.append(card)
    }
}
