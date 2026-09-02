//
//  PostDetailViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Combine
import Foundation

class PostDetailViewModel: ObservableObject {
    private var commentRepository: CommentRepository

    @Published var comments: [Comment] = []
    @Published var commentInput: String = ""
    @Published var sortOption: String = PostDetailViewModel.sortOptions[0]

    static let sortOptions = ["최신순", "오래된 순"]

    var sortedComments: [Comment] {
        switch sortOption {
        case PostDetailViewModel.sortOptions[1]:
            return comments.sorted { $0.createdAt < $1.createdAt }
        default:
            return comments.sorted { $0.createdAt > $1.createdAt }
        }
    }

    init(commentRepository: CommentRepository = MockCommentRepository()) {
        self.commentRepository = commentRepository
    }

    func loadComments() async {
        comments = await commentRepository.fetchComments()
    }

    // TODO: 실제 댓글 등록 API 연동 필요 — 지금은 로컬 목록에만 추가
    func submitComment() {
        let trimmed = commentInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        comments.append(
            Comment(id: UUID(), authorNickname: "나", authorLevel: 1, content: trimmed, createdAt: Date())
        )
        commentInput = ""
    }
}
