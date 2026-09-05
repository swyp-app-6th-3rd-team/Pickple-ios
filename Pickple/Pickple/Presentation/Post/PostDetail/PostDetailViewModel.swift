//
//  PostDetailViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Combine
import Foundation

class PostDetailViewModel: ObservableObject {
    private let postDetailRepository: PostDetailRepository
    private let commentRepository: CommentRepository

    @Published var post: PostDetail?
    @Published var comments: [Comment] = []
    @Published var commentInput: String = ""
    @Published var sortOption: String = PostDetailViewModel.sortOptions[0]
    @Published var currentImageIndex = 0
    @Published var selectedProductTab: PostDetailVoteSide = .first
    @Published var votedSide: PostDetailVoteSide?
    // 한 게시글에 원픽은 하나만 가능하고 취소할 수 없다.
    @Published var pickedCommentID: Int?
    @Published var editingCommentID: Int?

    // TODO: 실제 로그인 상태 연동 필요 — 지금은 항상 로그인된 것으로 취급(Mock)
    @Published var isLoggedIn = true

    static let sortOptions = ["최신순", "오래된 순"]
    // TODO: 실제 투표 결과 API 연동 필요 — 지금은 고정된 Mock 비율
    static let firstVotePercentage = 70
    static let secondVotePercentage = 30

    var firstLabel: String {
        post?.type == .ab ? PostDetailStrings.productAFallback : PostDetailStrings.voteSideFor
    }

    var secondLabel: String {
        post?.type == .ab ? PostDetailStrings.productBFallback : PostDetailStrings.voteSideAgainst
    }

    var displayedProduct: PostDetailProduct? {
        guard let post else { return nil }
        if post.type == .ab {
            return selectedProductTab == .first ? post.firstProduct : post.secondProduct
        }
        return post.firstProduct
    }

    var canPickAnyComment: Bool {
        pickedCommentID == nil
    }

    var isEditingComment: Bool {
        editingCommentID != nil
    }

    func isMyComment(_ comment: Comment) -> Bool {
        comment.mine
    }

    var sortedComments: [Comment] {
        return PostSortOrder.sorted(comments, ascending: sortOption == PostDetailViewModel.sortOptions[1]) { $0.createdAt }
    }

    init(
        voteType: VoteType,
        postDetailRepository: PostDetailRepository? = nil,
        commentRepository: CommentRepository = MockCommentRepository()
    ) {
        self.postDetailRepository = postDetailRepository ?? MockPostDetailRepository(type: voteType)
        self.commentRepository = commentRepository
    }

    func loadPostDetail() async {
        post = await postDetailRepository.fetchPostDetail()
    }

    func loadComments() async {
        comments = (try? await commentRepository.fetchComments()) ?? []
    }

    func submitComment() async {
        let trimmed = commentInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        do {
            if let editingCommentID {
                try await commentRepository.editComment(id: editingCommentID, content: trimmed)
                self.editingCommentID = nil
            } else {
                try await commentRepository.postComment(content: trimmed)
            }
            // 작성/수정 응답에 작성자·mine 같은 필드가 없어서, 성공하면 목록을 다시 받아 반영한다.
            await loadComments()
            commentInput = ""
        } catch {
            // TODO: 실패 시 사용자 안내(토스트 등) 필요 — 지금은 입력값을 유지만 한다.
        }
    }

    func startEditingComment(_ comment: Comment) {
        editingCommentID = comment.id
        commentInput = comment.content
    }

    func cancelEditingComment() {
        editingCommentID = nil
        commentInput = ""
    }

    func deleteComment(_ commentID: Int) async {
        guard (try? await commentRepository.deleteComment(id: commentID)) != nil else { return }
        comments.removeAll { $0.id == commentID }
        if editingCommentID == commentID {
            cancelEditingComment()
        }
    }

    // TODO: 실제 투표 API 연동 필요 — 지금은 로컬 상태만 변경
    func vote(_ side: PostDetailVoteSide) {
        guard votedSide == nil else { return }
        votedSide = side
    }

    func pickComment(_ commentID: Int) async {
        guard canPickAnyComment, let index = comments.firstIndex(where: { $0.id == commentID }) else { return }
        guard (try? await commentRepository.pickComment(id: commentID)) != nil else { return }
        comments[index].pickCount += 1
        pickedCommentID = commentID
    }

    func isPicked(_ commentID: Int) -> Bool {
        pickedCommentID == commentID
    }
}
