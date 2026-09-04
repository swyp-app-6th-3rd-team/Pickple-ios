//
//  BadgeMissionRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

protocol BadgeMissionRepository {
    // 유저가 아직 해제하지 못한 미션 중, 그룹(누적 투표 / 일일·연속 참여)별로 가장 낮은 단계 하나씩 반환.
    func fetchInProgressMissions() async throws -> [BadgeMissionProgress]
}
