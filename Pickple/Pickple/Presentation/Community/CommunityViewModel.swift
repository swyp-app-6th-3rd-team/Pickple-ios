//
//  CommunityViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Foundation
import SwiftUI

@Observable
class CommunityViewModel {
    private var communityRepository: CommunityRepository

    var posts: [PostSummary] = []
    var selectedCategory: String = CommunityViewModel.categories[0]
    var sortOption: String = CommunityViewModel.sortOptions[0]
    var isSortExpanded: Bool = false
    // 목록 스크롤을 최상단에서 일정 이상 내렸는지 — 최상단 이동 버튼 노출에 쓴다.
    var isScrolledDown: Bool = false
    // 최상단 이동 버튼이 쓰는 스크롤 위치 — ScrollViewReader+scrollTo(id:)의 구식 API 대신,
    // 같은 세대(iOS 17+)에 나온 ScrollPosition으로 CommunityPostListSection의 ScrollView와
    // 직접 바인딩한다.
    var scrollPosition = ScrollPosition()

    private var nextCursor: String?
    private(set) var hasNext: Bool = false
    private var isLoadingMore = false

    static let categories = ["전체", "패션/잡화", "전자제품", "생활용품", "뷰티", "기타"]
    static let sortOptions = ["최신순", "오래된 순"]
    static let scrollDownThreshold: CGFloat = 20

    var displayedPosts: [PostSummary] { posts }

    // 서버 sort 파라미터(API_SPEC)엔 OLDEST가 없다 — "오래된 순" 라벨은 유지하되, 백엔드가
    // 실제 OLDEST를 지원하기 전까지는 POPULAR로 임시 매핑한다(추후 교체 예정,
    // project_post_sort_api_limitation 메모 참고).
    private var serverSort: PostSortOption { isOldestSort ? .popular : .latest }
    private var isOldestSort: Bool { sortOption == CommunityViewModel.sortOptions[1] }
    private var serverCategory: String? { PostCategoryLabel.code(for: selectedCategory) }

    init(communityRepository: CommunityRepository = MockCommunityRepository()) {
        self.communityRepository = communityRepository
    }

    func loadPosts() async {
        nextCursor = nil
        hasNext = false
        do {
            let page = try await communityRepository.fetchPosts(category: serverCategory, sort: serverSort, cursor: nil)
            posts = page.items
            nextCursor = page.nextCursor
            hasNext = page.hasNext
        } catch {
            posts = []
            print("[Community] 게시글 로드 실패: \(error)")
        }
    }

    // 화면에 보이는 마지막 카드가 나타났을 때 호출.
    func loadMoreIfNeeded(currentPost post: PostSummary) async {
        guard post.id == posts.last?.id, hasNext, !isLoadingMore, let cursor = nextCursor else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }
        do {
            let page = try await communityRepository.fetchPosts(category: serverCategory, sort: serverSort, cursor: cursor)
            posts += page.items
            nextCursor = page.nextCursor
            hasNext = page.hasNext
        } catch {
            print("[Community] 추가 게시글 로드 실패: \(error)")
        }
    }
}
