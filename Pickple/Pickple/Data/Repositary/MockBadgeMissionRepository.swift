//
//  MockBadgeMissionRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Foundation

struct MockBadgeMissionRepository: BadgeMissionRepository {
    func fetchInProgressMissions() async -> [BadgeMissionProgress] {
        [
            BadgeMissionProgress(id: UUID(), title: "누적 투표 1,000회 달성", current: 0, target: 1000),
            BadgeMissionProgress(id: UUID(), title: "7일 연속 매일 투표 참여", current: 2, target: 7)
        ]
    }
}
