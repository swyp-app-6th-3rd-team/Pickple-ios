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
    @Published var pickedCommentID: UUID?
    @Published var editingCommentID: UUID?

    // TODO: 실제 로그인 상태 연동 필요 — 지금은 항상 로그인된 것으로 취급(Mock)
    @Published var isLoggedIn = true

    static let sortOptions = ["최신순", "오래된 순"]
    // TODO: 실제 투표 결과 API 연동 필요 — 지금은 고정된 Mock 비율
    static let firstVotePercentage = 70
    static let secondVotePercentage = 30

    var firstLabel: String {
        post?.type == .ab ? "상품A" : "사자"
    }

    var secondLabel: String {
        post?.type == .ab ? "상품B" : "말자"
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
        // TODO: 실제 로그인 사용자 식별 필요 — 지금은 Mock 작성자 닉네임("나")으로만 판별
        comment.authorNickname == "나"
    }

    var sortedComments: [Comment] {
        switch sortOption {
        case PostDetailViewModel.sortOptions[1]:
            return comments.sorted { $0.createdAt < $1.createdAt }
        default:
            return comments.sorted { $0.createdAt > $1.createdAt }
        }
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
        comments = await commentRepository.fetchComments()
    }

    // TODO: 실제 댓글 등록/수정 API 연동 필요 — 지금은 로컬 목록에만 반영
    func submitComment() {
        let trimmed = commentInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        if let editingCommentID, let index = comments.firstIndex(where: { $0.id == editingCommentID }) {
            let original = comments[index]
            comments[index] = Comment(
                id: original.id,
                authorNickname: original.authorNickname,
                authorLevel: original.authorLevel,
                authorProfileImageName: original.authorProfileImageName,
                content: trimmed,
                createdAt: original.createdAt,
                pickCount: original.pickCount
            )
            self.editingCommentID = nil
        } else {
            comments.append(
                Comment(id: UUID(), authorNickname: "나", authorLevel: 1, authorProfileImageName: "PickpleProfileSample", content: trimmed, createdAt: Date())
            )
        }
        commentInput = ""
    }

    func startEditingComment(_ comment: Comment) {
        editingCommentID = comment.id
        commentInput = comment.content
    }

    func cancelEditingComment() {
        editingCommentID = nil
        commentInput = ""
    }

    // TODO: 실제 댓글 삭제 API 연동 필요 — 지금은 로컬 목록에서만 제거
    func deleteComment(_ commentID: UUID) {
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

    // TODO: 실제 포인트 지급 API 연동 필요 — 댓글 작성자 +10P, 원픽한 나(글 작성자) +5P.
    // 지금은 원픽 횟수·선택 상태만 로컬로 반영
    func pickComment(_ commentID: UUID) {
        guard canPickAnyComment, let index = comments.firstIndex(where: { $0.id == commentID }) else { return }
        comments[index].pickCount += 1
        pickedCommentID = commentID
    }

    func isPicked(_ commentID: UUID) -> Bool {
        pickedCommentID == commentID
    }
}
