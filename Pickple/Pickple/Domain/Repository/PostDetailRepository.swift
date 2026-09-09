//
//  PostDetailRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

protocol PostDetailRepository {
    func fetchPostDetail() async throws -> PostDetail
}
