//
//  UserPostRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//

protocol UserPostRepository {
    //실제 API와 연동
    func fetchMyPosts() async -> [PostSummary]
    func fetchVotedPosts() async -> [PostSummary]
    func fetchCommentedPosts() async -> [PostSummary]
    func fetchWrittenPosts() async -> [PostSummary]
    
}
