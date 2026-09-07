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
    @State private var showsLoginRequired = false
    @State private var showsTypeSelection = false
    @State private var writeFlowType: VoteType?
    @State private var composePostViewModel = PostViewModel()

    var body: some View {
        ScrollViewReader { scrollProxy in
            ZStack {
                VStack(spacing: 0) {
                    CommunityHeaderView(communityViewModel: communityViewModel)
                    CommunityPostListSection(
                        communityViewModel: communityViewModel,
                        onTapPost: { post in communityRouter.push(.postDetail(postId: post.id, type: post.type)) }
                    )
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
                                    composePostViewModel = PostViewModel()
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
                    PostWriteFlowView(postViewModel: composePostViewModel)
                }
            }
        }
    }
}

#Preview {
    CommunityView(communityViewModel: CommunityViewModel())
        .environment(CommunityRouter())
}
