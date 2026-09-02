//
//  MyActivityViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//
import Combine

class MyActivityViewModel: ObservableObject {
    private var userPostRepository: UserPostRepository

    @Published var votedPosts: [PostSummary] = []      // 투표
    @Published var commentedPosts: [PostSummary] = []   // 댓글
    @Published var writtenPosts: [PostSummary] = []     // 작성글
    
    init(userPostRepository: UserPostRepository = MockUserPostRepository()) {
        self.userPostRepository = userPostRepository
    }

    func loadVotedPosts() async { votedPosts = await userPostRepository.fetchVotedPosts() }
    func loadCommentedPosts() async { commentedPosts = await userPostRepository.fetchCommentedPosts() }
    func loadWrittenPosts() async {writtenPosts = await userPostRepository.fetchWrittenPosts()}
}
