//
//  Comment.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Foundation

struct Comment: Identifiable {
    let id: UUID
    let authorNickname: String
    let authorLevel: Int
    let authorProfileImageName: String?
    let content: String
    let createdAt: Date
    var pickCount: Int = 0
}
