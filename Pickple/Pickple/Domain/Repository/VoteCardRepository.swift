//
//  VoteCardRepository.swift
//  Pickple
//
//  Created by 박윤수 on 8/31/26.
//

protocol VoteCardRepository {
    func fetchCards() async throws -> [VoteCard]
}
