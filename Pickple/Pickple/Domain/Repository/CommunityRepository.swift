//
//  CommunityRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

protocol CommunityRepository {
    func fetchPosts() async throws -> [PostSummary]
    // 홈 화면 "인기 게시글" 섹션 전용 (GET /posts/popular)
    func fetchPopularPosts() async throws -> [PostSummary]
}
