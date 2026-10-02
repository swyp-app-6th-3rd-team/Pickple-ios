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
    @Environment(\.showLoginPrompt) private var showLoginPrompt
    @Environment(\.apiClient) private var apiClient
    // "새 투표 올리기"를 커뮤니티 작성 버튼과 동일하게 동작시키는 데 쓴다 — 유형 선택
    // 시트 → 작성 화면(fullScreenCover) → 성공 시 상세로 push + 토스트, 순서까지 같다.
    @State private var showsTypeSelection = false
    @State private var writeFlowType: VoteType?
    @State private var composePostViewModel = PostViewModel()
    // 새 글 등록 성공 토스트는 이 화면이 아니라 상세 화면으로 push된 뒤에 보여야 해서,
    // 이 화면 자신의 토스트가 아니라 상위(PickpleBottomNav의 NavigationStack)에서 띄운다.
    var onPostCreated: () -> Void = {}
    // 아래로 스크롤하면 하단 탭바를 숨기는 데 쓴다 — PickpleTabView가 이걸로 전달받아
    // .toolbar(_, for: .tabBar) 노출 여부에 같이 반영한다.
    var isScrolledDown: Binding<Bool> = .constant(false)

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
                        MyPageProfileHeaderView(myPageViewModel: myPageViewModel, onLoginTapped: { showLoginPrompt(.main) })

                        MyPageStatusView(
                            myPageViewModel: myPageViewModel,
                            onTapStat: { tab in
                                if myPageViewModel.isLoggedIn {
                                    myPageRouter.push(.activity(initialTab: tab))
                                } else {
                                    showLoginPrompt(.myPosts)
                                }
                            }
                        )

                        MyPagePostView(
                            myPageViewModel: myPageViewModel,
                            onTapPost: { post in myPageRouter.push(.postDetail(postId: post.id, type: post.type)) },
                            onTapMore: {
                                if myPageViewModel.isLoggedIn {
                                    myPageRouter.push(.activity(initialTab: 0))
                                } else {
                                    showLoginPrompt(.myPosts)
                                }
                            },
                            onTapAddPost: {
                                // 게스트는 "내가 올린 투표" 영역 문구로 로그인 유도 모달을 띄운다.
                                // 로그인 상태면 커뮤니티의 작성 버튼과 똑같이 유형 선택 시트를 띄운다.
                                if myPageViewModel.isLoggedIn {
                                    composePostViewModel = PostViewModel(postWriteRepository: RemotePostWriteRepository(apiClient: apiClient))
                                    showsTypeSelection = true
                                } else {
                                    showLoginPrompt(.myPosts)
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
                                    showLoginPrompt(.myPageInfo)
                                }
                            },
                            onTapBadge: {
                                if myPageViewModel.isLoggedIn {
                                    myPageRouter.push(.badge)
                                } else {
                                    showLoginPrompt(.myPageInfo)
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
                                    showLoginPrompt(.myPageInfo)
                                }
                            }
                        )

                    }

            }
            .onTabBarHideScroll(isScrolledDown: isScrolledDown)
        }
        .task {
            await myPageViewModel.loadUserInfo()
            await myPageViewModel.loadMyPosts()
        }
        .sheet(isPresented: $showsTypeSelection) {
            PostTypeSelectionSheet { type in
                composePostViewModel.selectedType = type
                showsTypeSelection = false
                writeFlowType = type
            }
            .presentationDetents([.height(224)])
            .presentationDragIndicator(.visible)
        }
        .fullScreenCover(item: $writeFlowType) { _ in
            NavigationStack {
                // 성공 시 이 모달을 닫고, 마이페이지 탭의 실제 네비게이션 스택에 상세 화면을
                // push한다 — 그래야 상세 화면에서 뒤로가기를 누르면 작성 화면이 아니라
                // 마이페이지로 돌아간다.
                PostWriteFlowView(postViewModel: composePostViewModel, onPostSaved: { postId, type in
                    myPageRouter.push(.postDetail(postId: postId, type: type))
                    onPostCreated()
                })
            }
        }
    }
}

#Preview {
    MyPageView(myPageViewModel: MyPageViewModel())
        .environment(MyPageRouter())
}
