//
//  MyPageView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//
// 1차 점검 완료 - 9월 13일

import SwiftUI

struct MyPageView: View {
    let myPageViewModel: MyPageViewModel
    @Environment(MyPageRouter.self) private var myPageRouter
    @Environment(\.appRequestLogin) private var appRequestLogin
    @State private var showsLoginRequired = false
    @State private var showsMyPostsLoginRequired = false
    @State private var showsInfoLoginRequired = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Color.navy60
                    .ignoresSafeArea()
                Color.white
                    .ignoresSafeArea()
            }
            ScrollView {
                    VStack(spacing: 0) {
                        MyPageProfileHeaderView(myPageViewModel: myPageViewModel, onLoginTapped: { showsLoginRequired = true })

                        MyPageStatusView(
                            myPageViewModel: myPageViewModel,
                            onTapStat: { tab in
                                if myPageViewModel.isLoggedIn {
                                    myPageRouter.push(.activity(initialTab: tab))
                                } else {
                                    showsMyPostsLoginRequired = true
                                }
                            }
                        )

                        Rectangle()
                            .foregroundStyle(Color.neutral5)
                            .frame(height: 4)

                        MyPagePostView(
                            myPageViewModel: myPageViewModel,
                            onTapPost: { post in myPageRouter.push(.postDetail(postId: post.id, type: post.type)) },
                            onTapMore: {
                                if myPageViewModel.isLoggedIn {
                                    myPageRouter.push(.activity(initialTab: 2))
                                } else {
                                    showsMyPostsLoginRequired = true
                                }
                            },
                            onTapAddPost: {
                                // 게스트는 로그인 유도 모달을 띄운다. "내가 올린 투표" 영역 문구를 써야 해서
                                // 계정 관리/프로필 헤더가 쓰는 showsLoginRequired와 다이얼로그를 분리한다.
                                if !myPageViewModel.isLoggedIn {
                                    showsMyPostsLoginRequired = true
                                }
                            }
                        )

                        Rectangle()
                            .foregroundStyle(Color.neutral5)
                            .frame(height: 4)

                        MyPageInfoView(
                            onTapGrade: {
                                if myPageViewModel.isLoggedIn {
                                    myPageRouter.push(.grade)
                                } else {
                                    showsInfoLoginRequired = true
                                }
                            },
                            onTapBadge: {
                                if myPageViewModel.isLoggedIn {
                                    myPageRouter.push(.badge)
                                } else {
                                    showsInfoLoginRequired = true
                                }
                            }
                        )

                        Rectangle()
                            .foregroundStyle(Color.neutral5)
                            .frame(height: 4)

                        MyPageExtraView(
                            onTapAccount: {
                                if myPageViewModel.isLoggedIn {
                                    myPageRouter.push(.account)
                                } else {
                                    showsInfoLoginRequired = true
                                }
                            }
                        )

                    }

            }

            if showsLoginRequired {
                PickpleDialogOverlay {
                    PickpleConfirmDialog(
                        title: MainStrings.loginRequiredTitle,
                        description: MainStrings.loginRequiredDescription,
                        cancelTitle: MainStrings.cancel,
                        confirmTitle: MainStrings.login,
                        onCancel: { showsLoginRequired = false },
                        onConfirm: {
                            showsLoginRequired = false
                            appRequestLogin()
                        }
                    )
                }
            }

            if showsMyPostsLoginRequired {
                PickpleDialogOverlay {
                    PickpleConfirmDialog(
                        title: MyPageStrings.myPostsLoginRequiredTitle,
                        description: MyPageStrings.myPostsLoginRequiredDescription,
                        cancelTitle: MainStrings.cancel,
                        confirmTitle: MainStrings.login,
                        onCancel: { showsMyPostsLoginRequired = false },
                        onConfirm: {
                            showsMyPostsLoginRequired = false
                            appRequestLogin()
                        }
                    )
                }
            }

            if showsInfoLoginRequired {
                PickpleDialogOverlay {
                    PickpleConfirmDialog(
                        title: MyPageStrings.infoLoginRequiredTitle,
                        description: MyPageStrings.infoLoginRequiredDescription,
                        cancelTitle: MainStrings.cancel,
                        confirmTitle: MainStrings.login,
                        onCancel: { showsInfoLoginRequired = false },
                        onConfirm: {
                            showsInfoLoginRequired = false
                            appRequestLogin()
                        }
                    )
                }
            }
        }
        .task {
            await myPageViewModel.loadUserInfo()
            await myPageViewModel.loadMyPosts()
        }
    }
}

#Preview {
    MyPageView(myPageViewModel: MyPageViewModel())
        .environment(MyPageRouter())
}
