//
//  PostDetailView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 여백/폰트 크기, 아바타·더보기 아이콘은 임시값(전용 에셋 없음)

import SwiftUI

struct PostDetailView: View {
    let post: PostSummary
    // 방금 게시에 성공하고 넘어온 경우 진입 시 성공 토스트를 한 번 보여준다.
    var showsSuccessToastOnAppear: Bool = false

    @StateObject private var postDetailViewModel = PostDetailViewModel()
    @State private var isSortExpanded = false
    @State private var showsSuccessToast = false

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()

    init(
        post: PostSummary = PostDetailView.defaultMockPost,
        showsSuccessToastOnAppear: Bool = false
    ) {
        self.post = post
        self.showsSuccessToastOnAppear = showsSuccessToastOnAppear
    }

    var body: some View {
        VStack(spacing: 0) {
            PickpleGNB(
                leading: .button(icon: Image("PickpleArrowLeft"), action: {}),
                center: .text("게시글 상세"),
                trailing: .button(icon: Image(systemName: "ellipsis"), action: {})
            )

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 4) {
                        switch post.type {
                        case .text: Image("PickpleText").resizable().frame(width: 14, height: 14)
                        case .forAgainst: Image("PickpleAgainst").resizable().frame(width: 14, height: 14)
                        case .ab: Image("PickpleAB").resizable().frame(width: 14, height: 14)
                        }

                        Text(post.type.displayName)
                            .pickpleTypography(.caption)
                            .foregroundStyle(Color.green80)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().foregroundStyle(Color.green20))

                    Text(post.title)
                        .pickpleTypography(.title01)
                        .foregroundStyle(Color.black)

                    HStack(spacing: 8) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundStyle(Color.neutral20)

                        Text(post.authorNickname)
                            .pickpleTypography(.body02)
                            .foregroundStyle(Color.black)

                        Image("PickpleLevelBadge\(post.authorLevel)")
                            .resizable()
                            .frame(width: 16, height: 16)

                        Text("\(Self.dateFormatter.string(from: post.createdAt)) · \(post.createdAt.relativeTimeDescription)")
                            .pickpleTypography(.caption)
                            .foregroundStyle(Color.neutral40)
                    }

                    Text(post.description)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.neutral70)

                    Divider()

                    HStack {
                        Text("댓글 \(postDetailViewModel.comments.count)")
                            .pickpleTypography(.body01)
                            .foregroundStyle(Color.black)

                        Spacer()

                        PickpleSortButton(
                            isExpanded: .constant(false),
                            selectedValue: $postDetailViewModel.sortOption,
                            options: PostDetailViewModel.sortOptions
                        )
                        .floatingOverSiblings {
                            PickpleSortButton(
                                isExpanded: $isSortExpanded,
                                selectedValue: $postDetailViewModel.sortOption,
                                options: PostDetailViewModel.sortOptions
                            )
                        }
                    }
                    .zIndex(1)

                    if postDetailViewModel.comments.isEmpty {
                        VStack {
                            Spacer(minLength: 80)
                            Text("아직 작성된 댓글이 없어요")
                                .pickpleTypography(.body01)
                                .foregroundStyle(Color.neutral40)
                            Spacer(minLength: 80)
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(postDetailViewModel.sortedComments) { comment in
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 6) {
                                        Text(comment.authorNickname)
                                            .pickpleTypography(.body02)
                                            .foregroundStyle(Color.black)

                                        Image("PickpleLevelBadge\(comment.authorLevel)")
                                            .resizable()
                                            .frame(width: 14, height: 14)

                                        Text(comment.createdAt.relativeTimeDescription)
                                            .pickpleTypography(.caption)
                                            .foregroundStyle(Color.neutral40)
                                    }

                                    Text(comment.content)
                                        .pickpleTypography(.body01)
                                        .foregroundStyle(Color.neutral70)
                                }
                            }
                        }
                    }
                }
                .padding(20)
            }

            HStack(spacing: 8) {
                TextField("댓글 입력...", text: $postDetailViewModel.commentInput)
                    .pickpleTypography(.body02)
                    .padding(.horizontal, 16)
                    .frame(height: 44)
                    .background(Color.neutral5)
                    .clipShape(Capsule())

                Button(action: { postDetailViewModel.submitComment() }) {
                    Text("등록")
                        .pickpleTypography(.body02)
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 16)
                        .frame(height: 44)
                        .background(Color.black)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .pickpleToast(isPresented: $showsSuccessToast, message: PostViewStrings.submitSucceededToast)
        .task {
            await postDetailViewModel.loadComments()
            if showsSuccessToastOnAppear {
                showsSuccessToast = true
            }
        }
    }
}

extension PostDetailView {
    // 글 작성 플로우 완료 직후 실제 등록된 게시글 정보 없이 넘어오는 경우를 위한 임시 데이터.
    // TODO: 실제로는 방금 등록한 게시글의 서버 응답으로 대체 필요
    static let defaultMockPost = PostSummary(
        id: UUID(),
        type: .text,
        category: "패션/잡화",
        title: "나이키 에어포스 흰색으로 살까?",
        description: "데일리로 신을건데 나이키 에어포스 흰색 어때? 흰색 때타고 별로이려나? 검은색은 이미 있어서 이번에 흰 색도 사보려는데 어떻게 생각해?",
        imageName: "McokMyPostPicture",
        authorNickname: "닉네임",
        authorLevel: 5,
        voteCount: 0,
        commentCount: 0,
        createdAt: Date()
    )
}

#Preview {
    NavigationStack {
        PostDetailView(showsSuccessToastOnAppear: true)
    }
}
