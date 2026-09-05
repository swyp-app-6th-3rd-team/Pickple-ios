//
//  CommunityViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Combine
import Foundation

class CommunityViewModel: ObservableObject {
    private var communityRepository: CommunityRepository

    @Published var posts: [PostSummary] = []
    @Published var selectedCategory: String = CommunityViewModel.categories[0]
    @Published var sortOption: String = CommunityViewModel.sortOptions[0]
    @Published var isSortExpanded: Bool = false

    static let categories = ["전체", "패션/잡화", "전자제품", "생활용품", "뷰티", "기타"]
    static let sortOptions = ["최신순", "오래된 순"]
    static let scrollTopAnchor = "communityTop"

    var displayedPosts: [PostSummary] {
        let filtered = selectedCategory == CommunityViewModel.categories[0]
            ? posts
            : posts.filter { $0.category == selectedCategory }

        return PostSortOrder.sorted(filtered, ascending: sortOption == CommunityViewModel.sortOptions[1]) { $0.createdAt }
    }

    init(communityRepository: CommunityRepository = MockCommunityRepository()) {
        self.communityRepository = communityRepository
    }

    func loadPosts() async {
        posts = await communityRepository.fetchPosts()
    }
}
