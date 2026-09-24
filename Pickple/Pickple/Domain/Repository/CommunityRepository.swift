//
//  CommunityRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

// GET /posts 한 조각의 결과. nextCursor를 다음 요청에 그대로 넘기면 이어서 받고, hasNext가
// false면 더 없다는 뜻이다.
struct PostPage {
    let items: [PostSummary]
    let nextCursor: String?
    let hasNext: Bool
}

// GET /posts의 sort 파라미터(API_SPEC 기준) — LATEST/POPULAR만 있고 OLDEST는 없다.
// CommunityViewModel의 "오래된 순" 옵션은 이 제약 때문에 임시로 .popular에 매핑된다.
enum PostSortOption: String {
    case latest = "LATEST"
    case popular = "POPULAR"
}

protocol CommunityRepository {
    // category: 서버 enum 코드(FASHION 등). nil이면 전체. cursor: 이전 페이지의 nextCursor, nil이면 첫 페이지.
    func fetchPosts(category: String?, sort: PostSortOption, cursor: String?) async throws -> PostPage
    // 홈 화면 "인기 게시글" 섹션 전용 (GET /posts/popular)
    func fetchPopularPosts() async throws -> [PostSummary]
}
