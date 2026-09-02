//
//  PostSummary.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//
import Foundation

struct PostSummary: Identifiable {
    let id: UUID
    let type: VoteType
    let category: String
    let title: String
    let imageName: String       // 미리보기 썸네일 (여러 장 중 첫 장)
    let voteCount: Int
    let commentCount: Int
    let createdAt: Date

    //추후 API 스펙에 맞게 수정
}
