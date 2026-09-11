//
//  PostDetailView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 여백/폰트 크기는 임시값

import SwiftUI

struct PostDetailView: View {
    @State private var postDetailViewModel: PostDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.isLoggedIn) private var isLoggedIn
    @Environment(\.appRequestLogin) private var appRequestLogin
    @Environment(\.apiClient) private var apiClient
    
    @State private var isSortExpanded = false
    @State private var showsSuccessToast = false
    @State private var showsDeleteFailureToast = false
    @State private var showsMoreMenu = false
    @State private var postActionConfirm: PostDetailConfirmAction?
    @State private var loginRequiredDescription: String?
    @State private var commentToPick: Comment?
    @State private var commentMoreMenuTarget: Comment?
    @State private var navigatesToEdit = false
    @State private var editingPostViewModel = PostViewModel()
    @FocusState private var isCommentFieldFocused: Bool
    @State private var carouselBottomY: CGFloat = .infinity

    // 캐러셀 끝이 GNB 높이(56) 아래로 올라가면 이미지를 다 지나친 것으로 본다.
    private var isScrolledPastImage: Bool { carouselBottomY < 56 }
    
    init(
        voteType: VoteType = .text,
        postDetailRepository: PostDetailRepository? = nil,
        commentRepository: CommentRepository,
        userInfoRepository: UserInfoRepository,
        voteCardRepository: VoteCardRepository,
        guestVoteTracker: GuestVoteTracker = GuestVoteTracker()
    ) {
        _postDetailViewModel = State(initialValue: PostDetailViewModel(
            voteType: voteType,
            postDetailRepository: postDetailRepository,
            commentRepository: commentRepository,
            userInfoRepository: userInfoRepository,
            voteCardRepository: voteCardRepository,
            guestVoteTracker: guestVoteTracker
        ))
    }
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 0) {
                if postDetailViewModel.post?.type == .text {
                    PickpleGNB(
                        leading: .button(icon: Image("PickpleArrowLeft"), action: { dismiss() }),
                        center: .text(PostDetailStrings.navTitle),
                        trailing: .none
                    )
                }
                
                if let post = postDetailViewModel.post {
                    ScrollView {
                        PostDetailContent(
                            post: post,
                            postDetailViewModel: postDetailViewModel,
                            onMoreTapped: { showsMoreMenu = true },
                            onVote: { side in
                                Task {
                                    if await postDetailViewModel.vote(side) {
                                        loginRequiredDescription = PostDetailStrings.voteRequiredDescription
                                    }
                                }
                            },
                            onPickTapped: { comment in
                                if postDetailViewModel.canPickAnyComment {
                                    commentToPick = comment
                                }
                            },
                            onCommentMoreTapped: { comment in
                                commentMoreMenuTarget = comment
                            },
                            onLoginRequired: {
                                loginRequiredDescription = PostDetailStrings.commentViewRequiredDescription
                            },
                            isSortExpanded: $isSortExpanded
                        )
                    }
                    .coordinateSpace(name: "postDetailScroll")
                    .onPreferenceChange(CarouselBottomKey.self) { carouselBottomY = $0 }
                    // 캐러셀이 ScrollView 안에 있어서, 캐러셀만 ignoresSafeArea를 걸어도
                    // ScrollView 자체가 세이프에어리어 아래에서 시작해 위쪽이 비어 보인다.
                    // 찬반/A-B(GNB가 캐러셀 위에 떠 있는 타입)만 ScrollView 자체를 위로 확장한다.
                    .ignoresSafeArea(edges: post.type == .text ? [] : .top)
                }
                
                PostDetailCommentInputBar(text: $postDetailViewModel.commentInput, isFocused: $isCommentFieldFocused) {
                    if postDetailViewModel.isLoggedIn {
                        Task { await postDetailViewModel.submitComment() }
                    } else {
                        loginRequiredDescription = PostDetailStrings.commentRequiredDescription
                    }
                }
            }
            
            // 찬반/A-B는 캐러셀 이미지 위에 GNB가 떠 있다가, 스크롤로 이미지를 지나치면
            // 배경이 채워지고 타이틀이 나타난다. 스크롤뷰와 같은 흐름(VStack)에 넣지 않고
            // ZStack으로 그 위에 겹쳐 그린다.
            if postDetailViewModel.post?.type != .text {
                VStack {
                    PickpleGNB(
                        leading: .button(icon: Image("PickpleArrowLeft"), action: { dismiss() }),
                        center: isScrolledPastImage ? .text(PostDetailStrings.navTitle) : .none,
                        trailing: .none,
                        tint: isScrolledPastImage ? .black : .white,
                        background: Color.white.opacity(isScrolledPastImage ? 1 : 0)
                    )
                    .animation(.easeInOut(duration: 0.2), value: isScrolledPastImage)
                    Spacer()
                }
            }

            PostDetailDialogsOverlay(
                loginRequiredDescription: $loginRequiredDescription,
                postActionConfirm: $postActionConfirm,
                commentToPick: $commentToPick,
                showsDeleteFailureToast: $showsDeleteFailureToast,
                postDetailViewModel: postDetailViewModel,
                appRequestLogin: appRequestLogin,
                onDeleted: { dismiss() }
            )
        }
        .sheet(isPresented: $showsMoreMenu) {
            PostDetailMoreMenuSheet(
                isMine: postDetailViewModel.post?.isMine ?? true,
                onEdit: {
                    showsMoreMenu = false
                    if let post = postDetailViewModel.post {
                        editingPostViewModel = .editing(post, postWriteRepository: RemotePostWriteRepository(apiClient: apiClient))
                        navigatesToEdit = true
                    }
                },
                onDelete: {
                    showsMoreMenu = false
                    postActionConfirm = .delete
                },
                onReport: {
                    showsMoreMenu = false
                    postActionConfirm = .report
                },
                onBlock: {
                    showsMoreMenu = false
                    postActionConfirm = .block
                },
                onClose: { showsMoreMenu = false }
            )
        }
        .sheet(item: $commentMoreMenuTarget) { comment in
            PostDetailCommentMoreMenuSheet(
                isMine: postDetailViewModel.isMyComment(comment),
                onEdit: {
                    commentMoreMenuTarget = nil
                    postDetailViewModel.startEditingComment(comment)
                    isCommentFieldFocused = true
                },
                onDelete: {
                    commentMoreMenuTarget = nil
                    Task { await postDetailViewModel.deleteComment(comment.id) }
                },
                onReport: {
                    commentMoreMenuTarget = nil
                    //TODO: 실제 댓글 신고 API 연동 필요
                },
                onBlock: {
                    commentMoreMenuTarget = nil
                    //TODO: 실제 댓글 작성자 차단 API 연동 필요
                }
            )
        }
        .navigationDestination(isPresented: $navigatesToEdit) {
            // 수정 성공 후 새 상세 화면을 push하는 대신, 이 화면(이미 스택에 있던 원본)으로
            // 그냥 돌아와서 데이터만 새로 불러온다 — 그래야 뒤로가기가 작성 화면으로 되돌아가지 않는다.
            PostWriteFlowView(postViewModel: editingPostViewModel, onPostSaved: { _, _ in
                Task { await postDetailViewModel.loadPostDetail() }
                showsSuccessToast = true
            })
        }
        .pickpleToast(isPresented: $showsSuccessToast, message: PostViewStrings.submitEditSucceededToast)
        .pickpleToast(isPresented: $showsDeleteFailureToast, message: PostDetailStrings.deleteFailedToast)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .task {
            postDetailViewModel.isLoggedIn = isLoggedIn
            await postDetailViewModel.loadPostDetail()
            await postDetailViewModel.loadComments()
            await postDetailViewModel.loadMyProfileImage()
        }
    }
}

#Preview {
    NavigationStack {
        PostDetailView(
            voteType: .ab,
            commentRepository: MockCommentRepository(),
            userInfoRepository: MockUserInfoRepository(),
            voteCardRepository: MockVoteCardRepository()
        )
    }
}
