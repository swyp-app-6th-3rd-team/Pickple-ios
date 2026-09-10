//
//  CommunityViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Foundation

@Observable
class CommunityViewModel {
    private var communityRepository: CommunityRepository

    var posts: [PostSummary] = []
    var selectedCategory: String = CommunityViewModel.categories[0]
    var sortOption: String = CommunityViewModel.sortOptions[0]
    var isSortExpanded: Bool = false

    private var nextCursor: String?
    private(set) var hasNext: Bool = false
    private var isLoadingMore = false

    static let categories = ["전체", "패션/잡화", "전자제품", "생활용품", "뷰티", "기타"]
    static let sortOptions = ["최신순", "오래된 순"]
    static let scrollTopAnchor = "communityTop"

    // "오래된 순"은 서버 sort 파라미터(LATEST|POPULAR)에 대응하는 값이 없어서, 이때만 전체
    // 페이지를 다 받아와 클라이언트에서 오름차순으로 뒤집는다. "최신순"은 서버가 이미 그 순서로
    // 주는 페이지를 그대로 이어붙인다.
    var displayedPosts: [PostSummary] { posts }

    private var isOldestSort: Bool { sortOption == CommunityViewModel.sortOptions[1] }
    private var serverCategory: String? { PostCategoryLabel.code(for: selectedCategory) }

    init(communityRepository: CommunityRepository = MockCommunityRepository()) {
        self.communityRepository = communityRepository
    }

    func loadPosts() async {
        nextCursor = nil
        hasNext = false
        do {
            if isOldestSort {
                posts = PostSortOrder.sorted(try await fetchAllPosts(), ascending: true) { $0.createdAt }
            } else {
                let page = try await communityRepository.fetchPosts(category: serverCategory, cursor: nil)
                posts = page.items
                nextCursor = page.nextCursor
                hasNext = page.hasNext
            }
        } catch {
            posts = []
            print("[Community] 게시글 로드 실패: \(error)")
        }
    }

    // 화면에 보이는 마지막 카드가 나타났을 때 호출. "최신순"일 때만 다음 커서를 이어 받는다
    // ("오래된 순"은 loadPosts에서 이미 전체를 다 받아온 상태라 더 불러올 게 없다).
    func loadMoreIfNeeded(currentPost post: PostSummary) async {
        guard !isOldestSort, post.id == posts.last?.id, hasNext, !isLoadingMore, let cursor = nextCursor else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }
        do {
            let page = try await communityRepository.fetchPosts(category: serverCategory, cursor: cursor)
            posts += page.items
            nextCursor = page.nextCursor
            hasNext = page.hasNext
        } catch {
            print("[Community] 추가 게시글 로드 실패: \(error)")
        }
    }

    private func fetchAllPosts() async throws -> [PostSummary] {
        var all: [PostSummary] = []
        var cursor: String?
        while true {
            let page = try await communityRepository.fetchPosts(category: serverCategory, cursor: cursor)
            all += page.items
            guard page.hasNext, let next = page.nextCursor else { break }
            cursor = next
        }
        return all
    }
}
