//
//  MyGradeViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/8/26.
//
import Foundation

@Observable
class MyGradeViewModel {
    private var gradeRepository: GradeRepository

    var grades: [GradeCriteria] = []

    init(gradeRepository: GradeRepository = MockGradeRepository()) {
        self.gradeRepository = gradeRepository
    }

    @MainActor
    func loadGrades() async {
        grades = (try? await gradeRepository.fetchGrades()) ?? []
    }
}
