//
//  Untitled.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//
import Foundation

struct UserInfo: Identifiable {
    let id: UUID
    let nickname: String        // "픽플닉네임"
    let profileImageName: String
    let voteCount: Int          // 투표 3
    let commentCount: Int       // 댓글 34
    let postCount: Int          // 게시글 1
    let points: Int             // 현재 보유 포인트 1,890
    let level: Int              // LV. 1
    let pointsToNextLevel: Int  // 다음 레벨까지 1,110 P
}
