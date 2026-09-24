//
//  MainViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 8/31/26.
//
import Foundation

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

    @MainActor
    func loadHomeData() async {
        // 홈 화면 한 섹션 실패로 전체를 막지 않기 위해 실패하면 빈 배열로 둔다.
        async let missionsResult = try? badgeMissionRepository.fetchInProgressMissions()
        async let popularPostsResult = try? communityRepository.fetchPopularPosts()
        async let rankingsResult = try? pickerRankingRepository.fetchTopRankings()

        missions = await missionsResult ?? []
        hotPosts = Array((await popularPostsResult ?? []).filter { $0.type != .text })
        topRankings = await rankingsResult ?? []
    }

    // 투표 직후 미션 진행도만 다시 불러온다
    @MainActor
    func reloadMissions() async {
        missions = (try? await badgeMissionRepository.fetchInProgressMissions()) ?? []
    }
}
