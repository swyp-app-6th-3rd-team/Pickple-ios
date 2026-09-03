//
//  MockVoteCardRepository.swift
//  Pickple
//
//  Created by 박윤수 on 8/31/26.
//
import Foundation

struct MockVoteCardRepository: VoteCardRepository {
    func fetchCards() async -> [VoteCard] {
        [
            VoteCard(
                id: UUID(),
                type: .forAgainst,
                productName: "iPhone 17 Pro",
                concernText: "데일리로 쓸 폰 흰색 vs 오렌지색, 둘 다 예뻐서...",
                imageName: "MockAgainstPicture",
                secondImageName: nil,
                participantCount: 1234,
                firstPercentage: nil,
                secondPercentage: nil
            ),
            VoteCard(
                id: UUID(),
                type: .forAgainst,
                productName: "무선 이어폰",
                concernText: "이거 살까 말까 고민이에요",
                imageName: "MockAgainstPicture",
                secondImageName: nil,
                participantCount: 12,
                firstPercentage: nil,
                secondPercentage: nil
            ),
            VoteCard(
                id: UUID(),
                type: .ab,
                productName: "노트북 A vs B",
                concernText: "둘 중 뭐가 나을까요",
                imageName: "MockAgainstPicture",
                secondImageName: "MockAgainstPicture",
                participantCount: 8,
                firstPercentage: nil,
                secondPercentage: nil
            ),
        ]
    }
}
