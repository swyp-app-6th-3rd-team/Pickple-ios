//
//  CommunityView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 여백/간격은 임시값

import SwiftUI

struct CommunityView: View {
    @State var communityViewModel: CommunityViewModel
    @Environment(CommunityRouter.self) private var communityRouter
    @Environment(\.isLoggedIn) private var isLoggedIn
    @Environment(\.appRequestLogin) private var appRequestLogin
    @Environment(\.apiClient) private var apiClient
    @State private var showsLoginRequired = false
    @State private var showsTypeSelection = false
    @State private var writeFlowType: VoteType?
    @State private var composePostViewModel = PostViewModel()

    var body: some View {
        ScrollViewReader { scrollProxy in
            ZStack {
                VStack(spacing: 0) {
                    // 정렬 드롭박스가 펼쳐지면 아래 게시글 목록 영역까지 넘쳐서 그려지므로,
                    // 같은 VStack의 형제인 목록보다 위에 그려지도록 zIndex로 명시한다.
                    CommunityHeaderView(communityViewModel: communityViewModel)
                        .zIndex(1)
                    CommunityPostListSection(
                        communityViewModel: communityViewModel,
                        onTapPost: { post in communityRouter.push(.postDetail(postId: post.id, type: post.type)) }
                    )
                    .overlay {
                        // 드롭박스가 펼쳐진 동안 목록 쪽을 탭하면(게시글 탭 포함) 드롭박스만 접는다.
                        if communityViewModel.isSortExpanded {
                            Color.clear
                                .contentShape(Rectangle())
                                .onTapGesture { communityViewModel.isSortExpanded = false }
                        }
                    }
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Button(action: {
                                withAnimation {
                                    scrollProxy.scrollTo(CommunityViewModel.scrollTopAnchor, anchor: .top)
                                }
                            }) {
                                Image("PickpleArrowUp")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color.black)
                                    .padding(16)
                                    .background(Circle().foregroundStyle(Color.white))
                            }

                            Button(action: {
                                if isLoggedIn {
                                    composePostViewModel = PostViewModel(postWriteRepository: RemotePostWriteRepository(apiClient: apiClient))
                                    showsTypeSelection = true
                                } else {
                                    showsLoginRequired = true
                                }
                            }) {
                                Image("PickpleWriting")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color.white)
                                    .padding(16)
                                    .background(Circle().foregroundStyle(Color.black))
                            }
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }

                if showsLoginRequired {
                    PickpleDialogOverlay(onTapDismiss: { showsLoginRequired = false }) {
                        PickpleConfirmDialog(
                            title: CommunityStrings.loginRequiredTitle,
                            description: CommunityStrings.loginRequiredDescription,
                            cancelTitle: CommunityStrings.cancel,
                            confirmTitle: CommunityStrings.login,
                            onCancel: { showsLoginRequired = false },
                            onConfirm: {
                                showsLoginRequired = false
                                appRequestLogin()
                            }
                        )
                    }
                }
            }
            .task {
                await communityViewModel.loadPosts()
            }
            .onChange(of: communityViewModel.selectedCategory) { _, _ in
                Task { await communityViewModel.loadPosts() }
            }
            .onChange(of: communityViewModel.sortOption) { _, _ in
                Task { await communityViewModel.loadPosts() }
            }
            .sheet(isPresented: $showsTypeSelection) {
                PostTypeSelectionSheet { type in
                    composePostViewModel.selectedType = type
                    showsTypeSelection = false
                    writeFlowType = type
                }
                .padding(.horizontal, 20)
            }
            .fullScreenCover(item: $writeFlowType) { _ in
                NavigationStack {
                    // 성공 시 이 모달을 닫고, 커뮤니티 탭의 실제 네비게이션 스택에 상세 화면을
                    // push한다 — 그래야 상세 화면에서 뒤로가기를 누르면 작성 화면이 아니라
                    // 커뮤니티 목록으로 돌아간다.
                    PostWriteFlowView(postViewModel: composePostViewModel, onPostSaved: { postId, type in
                        communityRouter.push(.postDetail(postId: postId, type: type))
                    })
                }
            }
        }
    }
}

#Preview {
    CommunityView(communityViewModel: CommunityViewModel())
        .environment(CommunityRouter())
}
