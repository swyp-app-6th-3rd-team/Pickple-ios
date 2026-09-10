//
//  MyPageView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//

import SwiftUI

struct MyPageView: View {
    let myPageViewModel: MyPageViewModel
    @Environment(MyPageRouter.self) private var myPageRouter
    @Environment(\.appRequestLogin) private var appRequestLogin
    @State private var showsLoginRequired = false
    @State private var showsPostLoginRequired = false

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

                        Divider()
                            .frame(height: 4)
                            .background(Color.neutral5)

                        MyPagePostView(
                            myPageViewModel: myPageViewModel,
                            onTapPost: { post in myPageRouter.push(.postDetail(postId: post.id, type: post.type)) },
                            onTapMore: { myPageRouter.push(.activity) },
                            onTapAddPost: {
                                // 게스트는 로그인 유도 모달을 띄운다. 게시글 작성 문구를 써야 해서
                                // 계정 관리/프로필 헤더가 쓰는 showsLoginRequired와 다이얼로그를 분리한다.
                                if !myPageViewModel.isLoggedIn {
                                    showsPostLoginRequired = true
                                }
                            }
                        )

                        Divider()
                            .frame(height: 4)
                            .background(Color.neutral5)

                        MyPageInfoView(
                            isLoggedIn: myPageViewModel.isLoggedIn,
                            onTapGrade: { myPageRouter.push(.grade) },
                            onTapBadge: { myPageRouter.push(.badge) }
                        )

                        Divider()
                            .frame(height: 4)
                            .background(Color.neutral5)

                        MyPageExtraView(
                            onTapAccount: {
                                if myPageViewModel.isLoggedIn {
                                    myPageRouter.push(.account)
                                } else {
                                    showsLoginRequired = true
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
