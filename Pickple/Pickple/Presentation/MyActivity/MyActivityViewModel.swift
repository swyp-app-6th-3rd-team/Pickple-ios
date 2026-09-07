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

    init(userPostRepository: UserPostRepository = MockUserPostRepository()) {
        self.userPostRepository = userPostRepository
    }

    func loadVotedPosts() async { votedPosts = await userPostRepository.fetchVotedPosts() }
    func loadCommentedPosts() async { commentedActivities = await userPostRepository.fetchCommentedPosts() }
    func loadWrittenPosts() async {writtenPosts = await userPostRepository.fetchWrittenPosts()}

    func sorted(_ posts: [PostSummary], by option: String) -> [PostSummary] {
        PostSortOrder.sorted(posts, ascending: option != MyActivityStrings.latestSortOption) { $0.createdAt }
    }

    func sorted(_ activities: [MyCommentActivity], by option: String) -> [MyCommentActivity] {
        PostSortOrder.sorted(activities, ascending: option != MyActivityStrings.latestSortOption) { $0.createdAt }
    }
}
