//
//  UserPostRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//

protocol UserPostRepository {
    func fetchMyPosts() async -> [PostSummary]
    //실제 API와 연동
}
