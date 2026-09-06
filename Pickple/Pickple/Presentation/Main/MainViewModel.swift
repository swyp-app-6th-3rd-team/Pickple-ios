//
//  MainViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 8/31/26.
//
import Foundation
import SwiftUI

@Observable
class MainViewModel {
    private let badgeMissionRepository: BadgeMissionRepository
    private let communityRepository: CommunityRepository
    private let pickerRankingRepository: PickerRankingRepository

    var selectedType: VoteType = .forAgainst
    var missions: [BadgeMissionProgress] = []
    var hotPosts: [PostSummary] = []
    var topRankings: [PickerRanking] = []

    private(set) var isLoggedIn: Bool

    var selectedTypeIndex: Binding<Int> {
        Binding(
            get: { self.selectedType == .forAgainst ? 0 : 1 },
            set: { self.selectedType = $0 == 0 ? .forAgainst : .ab }
        )
    }

    // MainToggleButton(찬반/AB)용 — selectedTypeIndex와 같은 값을 Bool로 노출한다.
    var isABSelected: Binding<Bool> {
        Binding(
            get: { self.selectedType == .ab },
            set: { self.selectedType = $0 ? .ab : .forAgainst }
        )
    }

    init(
        badgeMissionRepository: BadgeMissionRepository = MockBadgeMissionRepository(),
        communityRepository: CommunityRepository = MockCommunityRepository(),
        pickerRankingRepository: PickerRankingRepository = MockPickerRankingRepository(),
        isLoggedIn: Bool = true
    ) {
        self.badgeMissionRepository = badgeMissionRepository
        self.communityRepository = communityRepository
        self.pickerRankingRepository = pickerRankingRepository
        self.isLoggedIn = isLoggedIn
    }

    // @Observable 프로퍼티를 갱신하는 메서드라 여기에만 MainActor를 명시한다(CLAUDE.md 규칙) —
    // 클래스 전체를 MainActor로 격리하면 init까지 격리돼서 MainView의 기본 파라미터 값
    // 평가 시점(MainActor 컨텍스트가 보장 안 됨)과 충돌한다.
    @MainActor
    func loadHomeData() async {
        // 홈 화면 한 섹션 실패로 전체를 막지 않기 위해 실패하면 빈 배열로 둔다.
        async let missionsResult = try? badgeMissionRepository.fetchInProgressMissions()
        async let popularPostsResult = try? communityRepository.fetchPopularPosts()
        async let rankingsResult = try? pickerRankingRepository.fetchTopRankings()

        missions = await missionsResult ?? []
        hotPosts = Array((await popularPostsResult ?? []).prefix(10))
        topRankings = await rankingsResult ?? []
    }
}
