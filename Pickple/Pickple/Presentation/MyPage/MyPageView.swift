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
    @State private var showsPostLoginRequired = false
    @State private var showsGradeLoginRequired = false
    @State private var showsBadgeLoginRequired = false
    @State private var showsViewAllLoginRequired = false

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

                        MyPageStatusView(myPageViewModel: myPageViewModel)

                        Rectangle()
                            .foregroundStyle(Color.neutral5)
                            .frame(height: 4)

                        MyPagePostView(
                            myPageViewModel: myPageViewModel,
                            onTapPost: { post in myPageRouter.push(.postDetail(postId: post.id, type: post.type)) },
                            onTapMore: {
                                if myPageViewModel.isLoggedIn {
                                    myPageRouter.push(.activity)
                                } else {
                                    showsViewAllLoginRequired = true
                                }
                            },
                            onTapAddPost: {
                                // 게스트는 로그인 유도 모달을 띄운다. 게시글 작성 문구를 써야 해서
                                // 계정 관리/프로필 헤더가 쓰는 showsLoginRequired와 다이얼로그를 분리한다.
                                if !myPageViewModel.isLoggedIn {
                                    showsPostLoginRequired = true
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
                                    showsGradeLoginRequired = true
                                }
                            },
                            onTapBadge: {
                                if myPageViewModel.isLoggedIn {
                                    myPageRouter.push(.badge)
                                } else {
                                    showsBadgeLoginRequired = true
                                }
                            }
                        )

                        Rectangle()
                            .foregroundStyle(Color.neutral5)
                            .frame(height: 4)

                        MyPageExtraView(
                            onTapAccount: {
                                    myPageRouter.push(.account)
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

            if showsPostLoginRequired {
                PickpleDialogOverlay {
                    PickpleConfirmDialog(
                        title: MyPageStrings.postLoginRequiredTitle,
                        description: MyPageStrings.postLoginRequiredDescription,
                        cancelTitle: MainStrings.cancel,
                        confirmTitle: MainStrings.login,
                        onCancel: { showsPostLoginRequired = false },
                        onConfirm: {
                            showsPostLoginRequired = false
                            appRequestLogin()
                        }
                    )
                }
            }

            if showsGradeLoginRequired {
                PickpleDialogOverlay {
                    PickpleConfirmDialog(
                        title: MyPageStrings.gradeLoginRequiredTitle,
                        description: MyPageStrings.gradeLoginRequiredDescription,
                        cancelTitle: MainStrings.cancel,
                        confirmTitle: MainStrings.login,
                        onCancel: { showsGradeLoginRequired = false },
                        onConfirm: {
                            showsGradeLoginRequired = false
                            appRequestLogin()
                        }
                    )
                }
            }

            if showsBadgeLoginRequired {
                PickpleDialogOverlay {
                    PickpleConfirmDialog(
                        title: MyPageStrings.badgeLoginRequiredTitle,
                        description: MyPageStrings.badgeLoginRequiredDescription,
                        cancelTitle: MainStrings.cancel,
                        confirmTitle: MainStrings.login,
                        onCancel: { showsBadgeLoginRequired = false },
                        onConfirm: {
                            showsBadgeLoginRequired = false
                            appRequestLogin()
                        }
                    )
                }
            }

            if showsViewAllLoginRequired {
                PickpleDialogOverlay {
                    PickpleConfirmDialog(
                        title: MyPageStrings.viewAllLoginRequiredTitle,
                        description: MyPageStrings.viewAllLoginRequiredDescription,
                        cancelTitle: MainStrings.cancel,
                        confirmTitle: MainStrings.login,
                        onCancel: { showsViewAllLoginRequired = false },
                        onConfirm: {
                            showsViewAllLoginRequired = false
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
