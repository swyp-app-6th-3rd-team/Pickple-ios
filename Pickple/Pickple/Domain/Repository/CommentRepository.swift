//
//  CommentRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

protocol CommentRepository {
    //실제 API와 연동
    func fetchComments() async -> [Comment]
}
