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
    let imageName: String
    let voteCount: Int
    let commentCount: Int
    let createdAt: Date
}
