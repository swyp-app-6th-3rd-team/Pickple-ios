//
//  MockPickerRankingRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Foundation

struct MockPickerRankingRepository: PickerRankingRepository {
    private static let all: [PickerRanking] = (1...30).map { rank in
        PickerRanking(
            id: UUID(),
            rank: rank,
            nickname: "닉네임",
            level: 5,
            profileImageName: nil,
            points: 1000
        )
    }

    func fetchTopRankings() async -> [PickerRanking] {
        Array(Self.all.prefix(5))
    }

    func fetchRankings(cursor: Int) async -> [PickerRanking] {
        Array(Self.all.dropFirst(cursor).prefix(10))
    }
}
