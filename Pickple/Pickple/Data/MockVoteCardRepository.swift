//
//  Untitled.swift
//  Pickple
//
//  Created by 박윤수 on 8/31/26.
//
import Foundation

struct MockVoteCardRepository: VoteCardRepository {
    func fetchCards() async -> [VoteCard] {
        [
            VoteCard(id: UUID(), type: .forAgainst, productName: "무선 이어폰", concernText: "이거 살까 말까 고민이에요", imageName: "MockAgainstPicture"),
            //VoteCard(id: UUID(), type: .compare, productName: "노트북 A vs B", concernText: "둘 중 뭐가 나을까요", imageName: "PickpleTitle"),
        ]
    }
}
