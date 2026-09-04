//
//  UserPostRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//

protocol UserPostRepository {
    func fetchMyPosts() async throws -> [PostSummary]
    // TODO: 투표한/댓글단/작성한 글을 각각 조회하는 API가 스펙에 없어서 아직 Mock — API 나오면 연동
    func fetchVotedPosts() async -> [PostSummary]
    func fetchCommentedPosts() async -> [PostSummary]
    func fetchWrittenPosts() async -> [PostSummary]
}
