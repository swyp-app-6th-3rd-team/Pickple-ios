//
//  PostDetailView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 여백/폰트 크기는 임시값

import SwiftUI

// 캐러셀 아래쪽 끝의 y좌표(스크롤 좌표계 기준)를 전달하는 데 쓰는 PreferenceKey.
private struct CarouselBottomKey: PreferenceKey {
    static var defaultValue: CGFloat = .infinity
    // 스크롤 콘텐츠의 다른 자식들도 전부 defaultValue(.infinity)를 암묵적으로 흘려보내므로,
    // "마지막 값 우선"으로 합치면 캐러셀이 설정한 실제 값이 뒤에서 덮어써진다.
    // .infinity를 min의 항등원으로 써서, 실제 값이 항상 이기도록 한다.
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = min(value, nextValue())
    }
}

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
                        center: .text("게시글 상세"),
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
                                    loginRequiredDescription = "간편 로그인 후 더 많은 투표에\n참여해 보세요"
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
                        loginRequiredDescription = "간편 로그인 후 댓글을\n작성할 수 있어요"
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
                        center: isScrolledPastImage ? .text("게시글 상세") : .none,
                        trailing: .none,
                        tint: isScrolledPastImage ? .black : .white,
                        background: Color.white.opacity(isScrolledPastImage ? 1 : 0)
                    )
                    .animation(.easeInOut(duration: 0.2), value: isScrolledPastImage)
                    Spacer()
                }
            }

            if let loginRequiredDescription {
                PostDetailDialogOverlay {
                    PickpleConfirmDialog(
                        title: "로그인이 필요해요",
                        description: loginRequiredDescription,
                        cancelTitle: "취소",
                        confirmTitle: "로그인",
                        onCancel: { self.loginRequiredDescription = nil },
                        onConfirm: { self.loginRequiredDescription = nil }
                    )
                }
            }
            
            if let postActionConfirm {
                PostDetailDialogOverlay {
                    PickpleConfirmDialog(
                        title: postActionConfirm.title,
                        description: postActionConfirm.description,
                        cancelTitle: "취소",
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
                PostDetailDialogOverlay {
                    PickpleConfirmDialog(
                        title: "해당 답변자를 픽할까요?",
                        description: "한 번 픽하면 취소할 수 없어요",
                        cancelTitle: "취소",
                        confirmTitle: "픽하기",
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

// 게시글 더보기 메뉴에서 트리거되는 확인 모달 3종(삭제/신고/차단).
private enum PostDetailConfirmAction {
    case delete
    case report
    case block

    var title: String {
        switch self {
        case .delete: "게시글을 삭제할까요?"
        case .report: "게시글을 신고할까요?"
        case .block: "게시자를 차단할까요?"
        }
    }

    var description: String {
        switch self {
        case .delete: "게시글을 삭제하면 다시는\n볼 수 없어요"
        case .report: "이유없이 신고 시 활동이\n제한될 수 있어요"
        case .block: "차단하면 이 게시자의 모든 게시물을\n다시는 볼 수 없어요"
        }
    }

    var confirmTitle: String {
        switch self {
        case .delete: "삭제"
        case .report: "신고"
        case .block: "차단"
        }
    }
}

// 화면 전체를 덮는 반투명 배경 위에 중앙 모달을 띄운다.
private struct PostDetailDialogOverlay<Content: View>: View {
    @ViewBuilder let content: Content
    
    var body: some View {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
        content
            .padding(.horizontal, 40)
    }
}

// 캐러셀/헤더/본문/투표/댓글까지 스크롤되는 본문 전체.
private struct PostDetailContent: View {
    let post: PostDetail
    @ObservedObject var postDetailViewModel: PostDetailViewModel
    let onMoreTapped: () -> Void
    let onVote: (PostDetailVoteSide) -> Void
    let onPickTapped: (Comment) -> Void
    let onCommentMoreTapped: (Comment) -> Void
    @Binding var isSortExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if post.type != .text {
                PostDetailImageCarousel(
                    images: post.images,
                    participantCount: post.participantCount,
                    currentIndex: $postDetailViewModel.currentImageIndex
                )
                // 캐러셀 자체의 프레임 아래쪽 끝 y좌표를 부모(PostDetailView)로 흘려보낸다.
                // 이 지점이 GNB 높이 아래로 올라가면 이미지를 다 지나쳤다는 뜻.
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .preference(
                                key: CarouselBottomKey.self,
                                value: geo.frame(in: .named("postDetailScroll")).maxY
                            )
                    }
                )
            }
            
            VStack(spacing: 16) {
                PostDetailHeaderSection(post: post, onMoreTapped: onMoreTapped)

                PostDetailProductVoteSection(post: post, postDetailViewModel: postDetailViewModel, onVote: onVote)

                Rectangle()
                    .frame(height: 8)
                    .foregroundStyle(Color.neutral5)
                
                PostDetailCommentSectionHeader(
                    count: postDetailViewModel.comments.count,
                    sortOption: $postDetailViewModel.sortOption,
                    isSortExpanded: $isSortExpanded
                )
                
                if postDetailViewModel.comments.isEmpty {
                    PostDetailCommentEmptyView()
                } else {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(postDetailViewModel.sortedComments) { comment in
                            PostDetailCommentRow(
                                comment: comment,
                                isPicked: postDetailViewModel.isPicked(comment.id),
                                canPick: postDetailViewModel.canPickAnyComment,
                                onMoreTapped: { onCommentMoreTapped(comment) },
                                onPickTapped: { onPickTapped(comment) }
                            )
                        }
                    }
                }
            }
            .padding(20)
        }
    }
}

#Preview {
    NavigationStack {
        PostDetailView(voteType: .ab, showsSuccessToastOnAppear: false)
    }
}
