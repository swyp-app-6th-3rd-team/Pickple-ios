//
//  Untitled.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//
import Foundation

struct MockUserInfoRepository: UserProfileRepository {
    func fetchUserProfile() async -> UserProfile {
        UserProfile(
            id: UUID(),
            nickname: "픽플닉네임",
            profileImageName: "PickpleProfileSample",
            voteCount: 3,
            commentCount: 34,
            postCount: 1,
            points: 1890,
            level: 1,
            pointsToNextLevel: 1110
        )
    }
}
