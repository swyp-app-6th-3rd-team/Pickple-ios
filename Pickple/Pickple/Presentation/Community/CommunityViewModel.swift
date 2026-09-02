//
//  CommunityViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Combine

class CommunityViewModel: ObservableObject {
    private var communityRepository: CommunityRepository

    @Published var posts: [PostSummary] = []
    @Published var selectedCategory: String = CommunityViewModel.categories[0]
    @Published var sortOption: String = CommunityViewModel.sortOptions[0]
    @Published var isSortExpanded: Bool = false

    static let categories = ["전체", "패션/잡화", "전자제품", "생활용품", "뷰티"]
    static let sortOptions = ["최신순", "오래된 순"]

    var displayedPosts: [PostSummary] {
        let filtered = selectedCategory == CommunityViewModel.categories[0]
            ? posts
            : posts.filter { $0.category == selectedCategory }

        switch sortOption {
        case CommunityViewModel.sortOptions[1]:
            return filtered.sorted { $0.createdAt < $1.createdAt }
        default:
            return filtered.sorted { $0.createdAt > $1.createdAt }
        }
    }

    init(communityRepository: CommunityRepository = MockCommunityRepository()) {
        self.communityRepository = communityRepository
    }

    func loadPosts() async {
        posts = await communityRepository.fetchPosts()
    }
}
