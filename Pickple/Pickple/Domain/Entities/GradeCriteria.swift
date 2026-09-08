//
//  GradeCriteria.swift
//  Pickple
//
//  Created by 박윤수 on 9/8/26.
//

struct GradeCriteria: Identifiable {
    var id: Int { level }
    let level: Int
    let name: String
    let requiredPoint: Int
    let requiredVoteCount: Int
}
