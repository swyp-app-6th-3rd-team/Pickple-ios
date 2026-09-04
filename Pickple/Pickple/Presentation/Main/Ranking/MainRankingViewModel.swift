//
//  MainRankingViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Combine
import Foundation

class MainRankingViewModel: ObservableObject {
    private let pickerRankingRepository: PickerRankingRepository

    @Published var rankings: [PickerRanking] = []
    @Published var isLoadingMore = false

    private var isLastPage = false

    // TODO: 실제 로그인 상태 연동 필요 — 지금은 항상 로그인된 것으로 취급
    var isLoggedIn = true
    // TODO: 실제로는 로그인한 유저 본인의 랭킹 데이터로 대체 필요
    let myRanking = PickerRanking(id: UUID(), rank: 24, nickname: "닉네임", level: 5, profileImageName: "PickpleProfileSample", points: 1000)

    init(pickerRankingRepository: PickerRankingRepository = MockPickerRankingRepository()) {
        self.pickerRankingRepository = pickerRankingRepository
    }

    // @Published 값을 갱신하는 메서드라 여기에만 MainActor를 명시한다(CLAUDE.md 규칙) —
    // 클래스 전체를 MainActor로 격리하면 init까지 격리돼서 MainRankingView의 프로퍼티
    // 기본값 평가 시점(MainActor 컨텍스트가 보장 안 됨)과 충돌한다.
    @MainActor
    func loadInitial() async {
        rankings = await pickerRankingRepository.fetchRankings(cursor: 0)
        isLastPage = rankings.count < 10
    }

    // 스크롤이 목록 하단 근접(마지막 항목 노출)했을 때 다음 페이지를 이어붙인다.
    @MainActor
    func loadMoreIfNeeded(currentItem: PickerRanking) async {
        guard currentItem.id == rankings.last?.id, !isLoadingMore, !isLastPage else { return }
        isLoadingMore = true
        let next = await pickerRankingRepository.fetchRankings(cursor: rankings.count)
        if next.isEmpty { isLastPage = true }
        rankings.append(contentsOf: next)
        isLoadingMore = false
    }
}
