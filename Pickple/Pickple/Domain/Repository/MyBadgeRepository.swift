//
//  MyBadgeRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

protocol MyBadgeRepository {
    func fetchMyBadges() async throws -> [MyBadge]
}
