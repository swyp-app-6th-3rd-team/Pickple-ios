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
    private let voteCardRepository: VoteCardRepository

    var post: PostDetail?
    var comments: [Comment] = []
    var commentInput: String = ""
    var sortOption: String = PostDetailViewModel.sortOptions[0]
    var currentImageIndex = 0
    var selectedProductTab: PostDetailVoteSide = .first
    var myProfileImageUrl: URL?
    // 한 게시글에 원픽은 하나만 가능하고 취소할 수 없다.
    var pickedCommentID: Int?
    var editingCommentID: Int?

    var isLoggedIn: Bool
    // 게스트 무료 투표 3회는 홈 카드스택과 공유된다(기능명세서 2.2·6.3 동일 문구) — 화면마다
    // 따로 세지 않도록 앱 전체에서 하나만 만들어 공유하는 GuestVoteTracker를 주입받는다.
    private let guestVoteTracker: GuestVoteTracker

    static let sortOptions = ["최신순", "오래된 순"]

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
        voteCardRepository: VoteCardRepository = MockVoteCardRepository(),
        isLoggedIn: Bool = true,
        guestVoteTracker: GuestVoteTracker = GuestVoteTracker()
    ) {
        self.postDetailRepository = postDetailRepository ?? MockPostDetailRepository(type: voteType)
        self.commentRepository = commentRepository
        self.userInfoRepository = userInfoRepository
        self.voteCardRepository = voteCardRepository
        self.isLoggedIn = isLoggedIn
        self.guestVoteTracker = guestVoteTracker
    }

    func loadPostDetail() async {
        do {
            post = try await postDetailRepository.fetchPostDetail()
        } catch {
            print("[PostDetail] 로드 실패: \(error)")
        }
    }

    // 성공하면 true — 화면 쪽에서 이 값을 보고 뒤로 나갈지 실패 토스트를 띄울지 정한다.
    func deletePost() async -> Bool {
        do {
            try await postDetailRepository.deletePost()
            return true
        } catch {
            print("[PostDetail] 삭제 실패: \(error)")
            return false
        }
    }

    // 게스트는 로그인 계정이 없어서 서버에 프로필 사진을 물어볼 수 없다 — 그 경우
    // myProfileImageUrl은 nil로 남고, 투표 버튼 쪽에서 기본 이미지로 대체해서 보여준다.
    func loadMyProfileImage() async {
        guard isLoggedIn else { return }
        myProfileImageUrl = try? await userInfoRepository.fetchUserInfo().profileImageUrl
    }

    // 게스트는 댓글 목록 조회가 서버에서 항상 인증 오류로 거부돼서(블러 처리 UI와 일치하는
    // 의도된 동작), 실패가 뻔한 요청을 보내는 대신 여기서 바로 건너뛴다.
    func loadComments() async {
        guard isLoggedIn else { return }
        do {
            comments = try await commentRepository.fetchComments()
        } catch {
            print("[Comment] 목록 로드 실패: \(error)")
        }
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
            print("[Comment] 작성/수정 실패: \(error)")
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
        do {
            try await commentRepository.deleteComment(id: commentID)
        } catch {
            print("[Comment] 삭제 실패: \(error)")
            return
        }
        comments.removeAll { $0.id == commentID }
        if editingCommentID == commentID {
            cancelEditingComment()
        }
    }

    // 게스트는 홈 카드스택과 공유하는 무료 투표 3회까지만 허용한다(기능명세서 6.3).
    // 반환값 true = 로그인 유도 모달을 띄워야 함(게스트 한도 초과). false = 투표 적용됐거나 이미 투표한 상태.
    @MainActor
    @discardableResult
    func vote(_ side: PostDetailVoteSide) async -> Bool {
        guard let post, post.votedSide == nil else { return false }
        guard let optionId = side == .first ? post.firstOptionId : post.secondOptionId else { return false }

        if !isLoggedIn {
            guard guestVoteTracker.registerVote() else { return true }
            // 게스트는 토큰이 없어서 서버에 실제로 투표할 방법이 없다 — 로컬에서만 결과를 흉내낸다.
            let firstPercentage = side == .first ? Int.random(in: 55...80) : Int.random(in: 20...45)
            self.post = post.votingApplied(selectedOptionId: optionId, firstPercentage: firstPercentage, secondPercentage: 100 - firstPercentage)
            return false
        }

        guard let result = try? await voteCardRepository.castVote(postId: post.id, optionId: optionId) else { return false }
        self.post = post.votingApplied(selectedOptionId: optionId, firstPercentage: result.firstPercentage, secondPercentage: result.secondPercentage)
        return false
    }

    func pickComment(_ commentID: Int) async {
        guard canPickAnyComment,
              let index = comments.firstIndex(where: { $0.id == commentID }),
              !comments[index].mine
        else {
            print("[Pick] canPickAnyComment=\(canPickAnyComment), commentID=\(commentID) 로컬에서 막힘")
            return
        }
        do {
            try await commentRepository.pickComment(id: commentID)
        } catch {
            print("[Pick] 원픽 요청 실패: \(error)")
            return
        }
        comments[index].pickCount += 1
        pickedCommentID = commentID
    }

    func isPicked(_ commentID: Int) -> Bool {
        pickedCommentID == commentID
    }
}
