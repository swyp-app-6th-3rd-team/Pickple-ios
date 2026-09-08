//
//  GradeRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/8/26.
//

protocol GradeRepository {
    func fetchGrades() async throws -> [GradeCriteria]
}
