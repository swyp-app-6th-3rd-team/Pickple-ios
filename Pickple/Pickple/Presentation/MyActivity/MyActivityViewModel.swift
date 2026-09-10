//
//  MyActivityViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//
import Foundation

@Observable
class MyActivityViewModel {
    private var userPostRepository: UserPostRepository

    var votedPosts: [PostSummary] = []                        // 투표
    var commentedActivities: [MyCommentActivity] = []          // 댓글
    var writtenPosts: [PostSummary] = []                       // 작성글

    private var votedCursor: String?
    private var votedHasNext = false
    private var isLoadingMoreVoted = false

    private var writtenCursor: String?
    private var writtenHasNext = false
    private var isLoadingMoreWritten = false

    init(userPostRepository: UserPostRepository = MockUserPostRepository()) {
        self.userPostRepository = userPostRepository
    }

    func loadVotedPosts() async {
        let page = await userPostRepository.fetchVotedPosts(cursor: nil)
        votedPosts = page.items
        votedCursor = page.nextCursor
        votedHasNext = page.hasNext
    }

    // 정렬 옵션으로 화면에 보이는 마지막 카드가 나타났을 때 호출. "오래된순"은 지금까지 받아온
    // 것만 뒤집어 보여주는 거라(CommunityViewModel과 동일한 트레이드오프), 더 불러올수록 갱신된다.
    func loadMoreVotedPostsIfNeeded(currentPost post: PostSummary) async {
        guard post.id == votedPosts.last?.id, votedHasNext, !isLoadingMoreVoted, let cursor = votedCursor else { return }
        isLoadingMoreVoted = true
        defer { isLoadingMoreVoted = false }
        let page = await userPostRepository.fetchVotedPosts(cursor: cursor)
        votedPosts += page.items
        votedCursor = page.nextCursor
        votedHasNext = page.hasNext
    }

    func loadCommentedPosts() async { commentedActivities = await userPostRepository.fetchCommentedPosts() }

    func loadWrittenPosts() async {
        let page = await userPostRepository.fetchWrittenPosts(cursor: nil)
        writtenPosts = page.items
        writtenCursor = page.nextCursor
        writtenHasNext = page.hasNext
    }

    func loadMoreWrittenPostsIfNeeded(currentPost post: PostSummary) async {
        guard post.id == writtenPosts.last?.id, writtenHasNext, !isLoadingMoreWritten, let cursor = writtenCursor else { return }
        isLoadingMoreWritten = true
        defer { isLoadingMoreWritten = false }
        let page = await userPostRepository.fetchWrittenPosts(cursor: cursor)
        writtenPosts += page.items
        writtenCursor = page.nextCursor
        writtenHasNext = page.hasNext
    }

    func sorted(_ posts: [PostSummary], by option: String) -> [PostSummary] {
        PostSortOrder.sorted(posts, ascending: option != MyActivityStrings.latestSortOption) { $0.createdAt }
    }

    func sorted(_ activities: [MyCommentActivity], by option: String) -> [MyCommentActivity] {
        PostSortOrder.sorted(activities, ascending: option != MyActivityStrings.latestSortOption) { $0.createdAt }
    }
}
