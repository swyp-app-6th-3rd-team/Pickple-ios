//
//  PostDetailViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Foundation

@Observable
class PostDetailViewModel {
    private let postDetailRepository: PostDetailRepository
    private let commentRepository: CommentRepository
    private let userInfoRepository: UserInfoRepository

    var post: PostDetail?
    var comments: [Comment] = []
    var commentInput: String = ""
    var sortOption: String = PostDetailViewModel.sortOptions[0]
    var currentImageIndex = 0
    var selectedProductTab: PostDetailVoteSide = .first
    var votedSide: PostDetailVoteSide?
    var myProfileImageUrl: URL?
    // 한 게시글에 원픽은 하나만 가능하고 취소할 수 없다.
    var pickedCommentID: Int?
    var editingCommentID: Int?

    var isLoggedIn: Bool
    // 게스트 무료 투표 3회는 홈 카드스택과 공유된다(기능명세서 2.2·6.3 동일 문구) — 화면마다
    // 따로 세지 않도록 앱 전체에서 하나만 만들어 공유하는 GuestVoteTracker를 주입받는다.
    private let guestVoteTracker: GuestVoteTracker

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
        commentRepository: CommentRepository = MockCommentRepository(),
        userInfoRepository: UserInfoRepository = MockUserInfoRepository(),
        isLoggedIn: Bool = true,
        guestVoteTracker: GuestVoteTracker = GuestVoteTracker()
    ) {
        self.postDetailRepository = postDetailRepository ?? MockPostDetailRepository(type: voteType)
        self.commentRepository = commentRepository
        self.userInfoRepository = userInfoRepository
        self.isLoggedIn = isLoggedIn
        self.guestVoteTracker = guestVoteTracker
    }

    func loadPostDetail() async {
        post = await postDetailRepository.fetchPostDetail()
    }

    // 게스트는 로그인 계정이 없어서 서버에 프로필 사진을 물어볼 수 없다 — 그 경우
    // myProfileImageUrl은 nil로 남고, 투표 버튼 쪽에서 기본 이미지로 대체해서 보여준다.
    func loadMyProfileImage() async {
        guard isLoggedIn else { return }
        myProfileImageUrl = try? await userInfoRepository.fetchUserInfo().profileImageUrl
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
    // 게스트는 홈 카드스택과 공유하는 무료 투표 3회까지만 허용한다(기능명세서 6.3).
    // 반환값 true = 로그인 유도 모달을 띄워야 함(게스트 한도 초과). false = 투표 적용됐거나 이미 투표한 상태.
    @discardableResult
    func vote(_ side: PostDetailVoteSide) -> Bool {
        guard votedSide == nil else { return false }
        if !isLoggedIn {
            guard guestVoteTracker.registerVote() else { return true }
        }
        votedSide = side
        return false
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
