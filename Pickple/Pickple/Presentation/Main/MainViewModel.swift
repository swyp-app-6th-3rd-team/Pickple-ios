//
//  MainViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 8/31/26.
//
import Combine
import Foundation
import SwiftUI

@MainActor
class MainViewModel: ObservableObject {
    private var badgeMissionRepository: BadgeMissionRepository
    private var communityRepository: CommunityRepository
    private var pickerRankingRepository: PickerRankingRepository

    @Published var selectedType: VoteType = .forAgainst
    @Published var missions: [BadgeMissionProgress] = []
    @Published var hotPosts: [PostSummary] = []
    @Published var topRankings: [PickerRanking] = []

    // TODO: 실제 로그인 상태 연동 필요 — 지금은 항상 로그인된 것으로 취급
    var isLoggedIn = true

    var selectedTypeIndex: Binding<Int> {
        Binding(
            get: { self.selectedType == .forAgainst ? 0 : 1 },
            set: { self.selectedType = $0 == 0 ? .forAgainst : .ab }
        )
    }

    init(
        badgeMissionRepository: BadgeMissionRepository = MockBadgeMissionRepository(),
        communityRepository: CommunityRepository = MockCommunityRepository(),
        pickerRankingRepository: PickerRankingRepository = MockPickerRankingRepository()
    ) {
        self.badgeMissionRepository = badgeMissionRepository
        self.communityRepository = communityRepository
        self.pickerRankingRepository = pickerRankingRepository
    }

    func loadHomeData() async {
        // 홈 화면 한 섹션 실패로 전체를 막지 않기 위해 실패하면 빈 배열로 둔다.
        async let missionsResult = try? badgeMissionRepository.fetchInProgressMissions()
        async let postsResult = communityRepository.fetchPosts()
        async let rankingsResult = pickerRankingRepository.fetchTopRankings()

        missions = await missionsResult ?? []
        let posts = await postsResult
        hotPosts = Array(
            posts
                .sorted { ($0.voteCount + $0.commentCount) > ($1.voteCount + $1.commentCount) }
                .prefix(10)
        )
        topRankings = await rankingsResult
    }
}
