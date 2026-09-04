//
//  PickerRankingRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

protocol PickerRankingRepository {
    // 홈 화면 TOP 5 미리보기.
    func fetchTopRankings() async -> [PickerRanking]
    // 전체 랭킹 화면. cursor 기준 10개씩 페이징.
    func fetchRankings(cursor: Int) async -> [PickerRanking]
}
