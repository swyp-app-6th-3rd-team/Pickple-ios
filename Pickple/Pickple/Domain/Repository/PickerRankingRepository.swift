//
//  PickerRankingRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

protocol PickerRankingRepository {
    // 홈 화면 TOP 5 미리보기.
    func fetchTopRankings() async throws -> [PickerRanking]
    // 전체 랭킹 화면. cursor는 이전 응답의 nextCursor. 없으면(nil) 첫 조각.
    func fetchRankings(cursor: String?) async throws -> RankingPage
}
