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
    let content: String
    let createdAt: Date
}
