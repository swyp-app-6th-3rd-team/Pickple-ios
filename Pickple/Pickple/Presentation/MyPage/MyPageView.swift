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
                                // 게스트는 명세대로 로그인 유도 모달을 띄운다.
                                if !myPageViewModel.isLoggedIn {
                                    showsLoginRequired = true
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
