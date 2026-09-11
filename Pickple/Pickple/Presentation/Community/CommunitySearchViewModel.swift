//
//  CommunitySearchViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//

import Foundation

@Observable
class CommunitySearchViewModel {
    private let communityRepository: CommunityRepository
    private let userDefaults: UserDefaults
    private static let recentSearchesKey = "community.recentSearches"
    private static let recentSearchesLimit = 10

    var searchText: String = ""
    // 실시간 검색이 아니라 제출(키보드 검색 버튼)해야 반영되는 실제 조회 대상.
    // results/화면 분기 모두 searchText가 아니라 이 값을 기준으로 삼는다.
    private(set) var submittedSearchText: String = ""
    private(set) var recentSearches: [String] = []
    private var posts: [PostSummary] = []

    // 제출된 검색어가 비어있으면 아무 결과도 보여주지 않는다(전체 목록을 다시 보여주는 화면이
    // 아니라 검색 전용 화면이라, 빈 검색어에는 빈 상태가 자연스럽다).
    var results: [PostSummary] {
        guard !submittedSearchText.isEmpty else { return [] }
        return posts.filter { $0.title.localizedCaseInsensitiveContains(submittedSearchText) }
    }

    init(communityRepository: CommunityRepository = MockCommunityRepository(), userDefaults: UserDefaults = .standard) {
        self.communityRepository = communityRepository
        self.userDefaults = userDefaults
        self.recentSearches = userDefaults.stringArray(forKey: Self.recentSearchesKey) ?? []
    }

    // 검색 대상은 전체 게시글이어야 하므로, 서버가 커서로 나눠주는 페이지를 hasNext가
    // 끝날 때까지 모두 받아온다(첫 페이지만 받으면 뒤쪽 게시글은 검색에서 빠진다).
    func loadPosts() async {
        var all: [PostSummary] = []
        var cursor: String?
        do {
            while true {
                let page = try await communityRepository.fetchPosts(category: nil, cursor: cursor)
                all += page.items
                guard page.hasNext, let next = page.nextCursor else { break }
                cursor = next
            }
            posts = all
        } catch {
            posts = all
            print("[CommunitySearch] 게시글 로드 실패: \(error)")
        }
    }

    // 검색을 실행(제출)할 때만 기록한다 — 타이핑 중간중간이 아니라 실제로 찾아본 검색어만 남긴다.
    // 동시에 submittedSearchText를 갱신해 그 시점의 검색어로만 results가 필터링되게 한다.
    func recordSearch() {
        let term = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !term.isEmpty else { return }

        submittedSearchText = term
        recentSearches.removeAll { $0 == term }
        recentSearches.insert(term, at: 0)
        if recentSearches.count > Self.recentSearchesLimit {
            recentSearches.removeLast(recentSearches.count - Self.recentSearchesLimit)
        }
        userDefaults.set(recentSearches, forKey: Self.recentSearchesKey)
    }

    func selectRecentSearch(_ term: String) {
        searchText = term
        recordSearch()
    }

    // 검색창을 비우면(X 버튼) 결과 화면이 아니라 최근 검색어 화면으로 돌아가야 한다.
    func clearSearch() {
        submittedSearchText = ""
    }

    func removeRecentSearch(_ term: String) {
        recentSearches.removeAll { $0 == term }
        userDefaults.set(recentSearches, forKey: Self.recentSearchesKey)
    }

    func clearAllRecentSearches() {
        recentSearches = []
        userDefaults.removeObject(forKey: Self.recentSearchesKey)
    }
}
