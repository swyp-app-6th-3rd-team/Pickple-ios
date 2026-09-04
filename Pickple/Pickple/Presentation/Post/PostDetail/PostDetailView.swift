//
//  PostDetailView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 여백/폰트 크기는 임시값

import SwiftUI

struct PostDetailView: View {
    var showsSuccessToastOnAppear: Bool = false
    
    @StateObject private var postDetailViewModel: PostDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var isSortExpanded = false
    @State private var showsSuccessToast = false
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
    
    init(voteType: VoteType = .text, showsSuccessToastOnAppear: Bool = false) {
        self.showsSuccessToastOnAppear = showsSuccessToastOnAppear
        _postDetailViewModel = StateObject(wrappedValue: PostDetailViewModel(voteType: voteType))
    }
    
    var body: some View {
        ZStack {
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
                                if postDetailViewModel.isLoggedIn {
                                    postDetailViewModel.vote(side)
                                } else {
                                    loginRequiredDescription = PostDetailStrings.voteRequiredDescription
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
                        postDetailViewModel.submitComment()
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

            if let loginRequiredDescription {
                PickpleDialogOverlay {
                    PickpleConfirmDialog(
                        title: PostDetailStrings.voteRequiredTitle,
                        description: loginRequiredDescription,
                        cancelTitle: PostDetailStrings.cancel,
                        confirmTitle: PostDetailStrings.login,
                        onCancel: { self.loginRequiredDescription = nil },
                        onConfirm: { self.loginRequiredDescription = nil }
                    )
                }
            }
            
            if let postActionConfirm {
                PickpleDialogOverlay {
                    PickpleConfirmDialog(
                        title: postActionConfirm.title,
                        description: postActionConfirm.description,
                        cancelTitle: PostDetailStrings.cancel,
                        confirmTitle: postActionConfirm.confirmTitle,
                        onCancel: { self.postActionConfirm = nil },
                        onConfirm: {
                            switch postActionConfirm {
                            case .delete:
                                //TODO: 실제 게시글 삭제 API 연동 필요
                                dismiss()
                            case .report:
                                break //TODO: 실제 신고 API 연동 필요
                            case .block:
                                break //TODO: 기능명세서상 차단은 확인 모달만 있고 실제 동작은 정의되어 있지 않음
                            }
                            self.postActionConfirm = nil
                        }
                    )
                }
            }
            
            if let comment = commentToPick {
                PickpleDialogOverlay {
                    PickpleConfirmDialog(
                        title: PostDetailStrings.pickConfirmTitle,
                        description: PostDetailStrings.pickConfirmDescription,
                        cancelTitle: PostDetailStrings.cancel,
                        confirmTitle: PostDetailStrings.pickConfirmButton,
                        onCancel: { commentToPick = nil },
                        onConfirm: {
                            postDetailViewModel.pickComment(comment.id)
                            commentToPick = nil
                        }
                    )
                }
            }
        }
        .sheet(isPresented: $showsMoreMenu) {
            PostDetailMoreMenuSheet(
                isMine: postDetailViewModel.post?.isMine ?? true,
                onEdit: {
                    showsMoreMenu = false
                    if let post = postDetailViewModel.post {
                        editingPostViewModel = .editing(post)
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
                    postDetailViewModel.deleteComment(comment.id)
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
            PostWriteFlowView(postViewModel: editingPostViewModel)
        }
        .pickpleToast(isPresented: $showsSuccessToast, message: PostViewStrings.submitSucceededToast)
        .navigationBarBackButtonHidden(true)
        .task {
            await postDetailViewModel.loadPostDetail()
            await postDetailViewModel.loadComments()
            if showsSuccessToastOnAppear {
                showsSuccessToast = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        PostDetailView(voteType: .ab, showsSuccessToastOnAppear: false)
    }
}
