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
    private var votedSort: ActivitySortOrder = .latest

    private var writtenCursor: String?
    private var writtenHasNext = false
    private var isLoadingMoreWritten = false
    private var writtenSort: ActivitySortOrder = .latest

    init(userPostRepository: UserPostRepository = MockUserPostRepository()) {
        self.userPostRepository = userPostRepository
    }

    func loadVotedPosts(sort: ActivitySortOrder) async {
        votedSort = sort
        let page = await userPostRepository.fetchVotedPosts(cursor: nil, sort: sort)
        votedPosts = page.items
        votedCursor = page.nextCursor
        votedHasNext = page.hasNext
    }

    // 화면에 보이는 마지막 카드가 나타났을 때 호출 — 정렬은 마지막으로 loadVotedPosts에 넘긴
    // 값(votedSort)을 그대로 이어서 쓴다.
    func loadMoreVotedPostsIfNeeded(currentPost post: PostSummary) async {
        guard post.id == votedPosts.last?.id, votedHasNext, !isLoadingMoreVoted, let cursor = votedCursor else { return }
        isLoadingMoreVoted = true
        defer { isLoadingMoreVoted = false }
        let page = await userPostRepository.fetchVotedPosts(cursor: cursor, sort: votedSort)
        votedPosts += page.items
        votedCursor = page.nextCursor
        votedHasNext = page.hasNext
    }

    func loadCommentedPosts(sort: ActivitySortOrder) async {
        commentedActivities = await userPostRepository.fetchCommentedPosts(sort: sort)
    }

    func loadWrittenPosts(sort: ActivitySortOrder) async {
        writtenSort = sort
        let page = await userPostRepository.fetchWrittenPosts(cursor: nil, sort: sort)
        writtenPosts = page.items
        writtenCursor = page.nextCursor
        writtenHasNext = page.hasNext
    }

    func loadMoreWrittenPostsIfNeeded(currentPost post: PostSummary) async {
        guard post.id == writtenPosts.last?.id, writtenHasNext, !isLoadingMoreWritten, let cursor = writtenCursor else { return }
        isLoadingMoreWritten = true
        defer { isLoadingMoreWritten = false }
        let page = await userPostRepository.fetchWrittenPosts(cursor: cursor, sort: writtenSort)
        writtenPosts += page.items
        writtenCursor = page.nextCursor
        writtenHasNext = page.hasNext
    }
}
