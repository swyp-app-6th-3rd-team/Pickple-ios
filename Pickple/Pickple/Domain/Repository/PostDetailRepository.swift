//
//  PostDetailRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

protocol PostDetailRepository {
    //실제 API와 연동
    func fetchPostDetail() async -> PostDetail
}
