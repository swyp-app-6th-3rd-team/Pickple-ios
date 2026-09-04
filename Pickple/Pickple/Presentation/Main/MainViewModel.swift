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
    // nonisolated init에서 대입만 하고 이후로는 재대입 없이 읽기만 하므로 nonisolated(unsafe)+let로 둔다.
    nonisolated(unsafe) private let badgeMissionRepository: BadgeMissionRepository
    nonisolated(unsafe) private let communityRepository: CommunityRepository
    nonisolated(unsafe) private let pickerRankingRepository: PickerRankingRepository

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

    // 프로퍼티 대입만 하고 MainActor가 필요한 작업은 없어서 nonisolated로 뺀다.
    // 이래야 MainView처럼 아직 화면 계층에 안 붙은(=MainActor 컨텍스트가 보장 안 되는) 곳의
    // 기본 파라미터 값 등에서도 이 초기화를 호출할 수 있다.
    nonisolated init(
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
