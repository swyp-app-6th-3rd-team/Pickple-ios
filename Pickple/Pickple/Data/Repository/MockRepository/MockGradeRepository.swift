//
//  MockGradeRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/8/26.
//

struct MockGradeRepository: GradeRepository {
    func fetchGrades() async -> [GradeCriteria] {
        [
            GradeCriteria(level: 1, name: "LV.1", requiredPoint: 0, requiredVoteCount: 0),
            GradeCriteria(level: 2, name: "LV.2", requiredPoint: 200, requiredVoteCount: 20),
            GradeCriteria(level: 3, name: "LV.3", requiredPoint: 1_000, requiredVoteCount: 100),
            GradeCriteria(level: 4, name: "LV.4", requiredPoint: 3_500, requiredVoteCount: 300),
            GradeCriteria(level: 5, name: "LV.5", requiredPoint: 10_000, requiredVoteCount: 1_000),
        ]
    }
}
