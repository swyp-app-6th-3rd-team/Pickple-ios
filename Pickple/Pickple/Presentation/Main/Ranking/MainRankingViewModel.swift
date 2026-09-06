//
//  MainRankingViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Foundation

@Observable
class MainRankingViewModel {
    private let pickerRankingRepository: PickerRankingRepository

    var rankings: [PickerRanking] = []
    var isLoadingMore = false

    private var nextCursor: String?

    private(set) var isLoggedIn: Bool
    // TODO: 실제로는 로그인한 유저 본인의 랭킹 데이터로 대체 필요
    let myRanking = PickerRanking(id: UUID(), rank: 24, nickname: "닉네임", level: 5, profileImageName: "PickpleProfileSample", points: 1000)

    init(pickerRankingRepository: PickerRankingRepository = MockPickerRankingRepository(), isLoggedIn: Bool = true) {
        self.pickerRankingRepository = pickerRankingRepository
        self.isLoggedIn = isLoggedIn
    }

    // @Observable 프로퍼티를 갱신하는 메서드라 여기에만 MainActor를 명시한다(CLAUDE.md 규칙) —
    // 클래스 전체를 MainActor로 격리하면 init까지 격리돼서 MainRankingView의 프로퍼티
    // 기본값 평가 시점(MainActor 컨텍스트가 보장 안 됨)과 충돌한다.
    @MainActor
    func loadInitial() async {
        guard let page = try? await pickerRankingRepository.fetchRankings(cursor: nil) else { return }
        rankings = page.items
        nextCursor = page.nextCursor
    }

    // 스크롤이 목록 하단 근접(마지막 항목 노출)했을 때 다음 페이지를 이어붙인다.
    @MainActor
    func loadMoreIfNeeded(currentItem: PickerRanking) async {
        guard currentItem.id == rankings.last?.id, !isLoadingMore, nextCursor != nil else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }
        guard let page = try? await pickerRankingRepository.fetchRankings(cursor: nextCursor) else { return }
        rankings.append(contentsOf: page.items)
        nextCursor = page.nextCursor
    }
}
