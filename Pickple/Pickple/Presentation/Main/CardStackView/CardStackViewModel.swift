//
//  CardStackViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 8/31/26.
//
import Combine

class CardStackViewModel: ObservableObject {
    private var voteCardRepository: VoteCardRepository
    
    @Published var voteCardData: [VoteCard] = []
    
    init(voteCardRepository: VoteCardRepository = MockVoteCardRepository()) {
        self.voteCardRepository = voteCardRepository
    }
    
    func loadCards() async {
        voteCardData = await voteCardRepository.fetchCards()
    }

    func removeTopCard() {
        guard !voteCardData.isEmpty else { return }
        voteCardData.removeFirst()
    }
}
