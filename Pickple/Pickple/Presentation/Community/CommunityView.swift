//
//  CommunityView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  1차 점검 완료 - 9월 12일

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
    // 새 글 등록 성공 토스트는 이 화면이 아니라 상세 화면으로 push된 뒤에 보여야 해서,
    // 이 화면 자신의 토스트가 아니라 상위(PickpleBottomNav의 NavigationStack)에서 띄운다.
    var onPostCreated: () -> Void = {}
    // 하단 탭바 숨김/노출 전용 — CommunityPostListSection이 스크롤 방향을 알려주면 그대로
    // 위(PickpleBottomNav)에 전달한다. communityViewModel.isScrolledDown(최상단 이동
    // 버튼용, 위치 기준)과는 별개다.
    var onScrolledDownChange: (Bool) -> Void = { _ in }
    // 탭바가 숨겨지면 세이프에어리어가 바뀌면서 이 화면의 우측하단 버튼들 위치도 같이
    // 내려가는데, 그 이동엔 애니메이션이 안 걸려있었다 — 탭바 방향 신호를 로컬에도
    // 보관해서 버튼 위치에 같은 애니메이션을 걸어준다.
    @State private var isTabBarHiding = false

    var body: some View {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // 정렬 드롭박스가 펼쳐지면 아래 게시글 목록 영역까지 넘쳐서 그려지므로,
                    // 같은 VStack의 형제인 목록보다 위에 그려지도록 zIndex로 명시한다.
                    CommunityHeaderView(communityViewModel: communityViewModel)
                        .zIndex(1)
                    CommunityPostListSection(
                        communityViewModel: communityViewModel,
                        onTapPost: { post in communityRouter.push(.postDetail(postId: post.id, type: post.type)) },
                        onScrollDirectionChange: { scrolledDown in
                            isTabBarHiding = scrolledDown
                            onScrolledDownChange(scrolledDown)
                        }
                    )
                }
                // 헤더의 빈 공간(정렬 버튼 옆)까지 포함해서 화면 어디를 탭해도 드롭박스가
                // 접히게 한다. 게시글 탭 등 다른 제스처는 simultaneousGesture라 막지 않아서,
                // 드롭박스가 펼쳐진 채로 게시글을 눌러도 닫기+이동이 한 번의 탭으로 끝난다.
                // Spacer 같은 실제로 안 그려지는 빈 공간은 contentShape 없이는 애초에
                // 히트테스트 영역이 아니라 제스처 자체가 인식되지 않는다.
                .contentShape(Rectangle())
                .simultaneousGesture(
                    TapGesture().onEnded {
                        if communityViewModel.isSortExpanded {
                            withAnimation(.spring()) {
                                communityViewModel.isSortExpanded = false
                            }
                        }
                    }
                )

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            if communityViewModel.isScrolledDown {
                                Button(action: {
                                    withAnimation {
                                        communityViewModel.scrollPosition.scrollTo(edge: .top)
                                    }
                                }) {
                                    Image("PickpleArrowUp")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(Color.black)
                                        .padding(16)
                                        .background(Circle().foregroundStyle(Color.white))
                                        .shadow(color: Color.black.opacity(0.12), radius: 6)
                                }
                                .transition(.opacity.combined(with: .scale))
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
                        .animation(.easeInOut(duration: 0.2), value: communityViewModel.isScrolledDown)
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
                // 탭바 숨김으로 세이프에어리어가 바뀌어 이 버튼들 위치가 밀릴 때도 같은
                // 애니메이션으로 자연스럽게 움직이게 한다.
                .animation(.easeInOut(duration: 0.2), value: isTabBarHiding)

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
            // .task는 이 화면이 다시 나타날 때마다(상세화면 갔다가 뒤로가기 등) 재실행된다
            // (SwiftUI 공식 동작) — 그 사이 게시글 삭제 등 변동이 있었을 수 있어 매번 새로 불러온다.
            .task {
                await communityViewModel.loadPosts()
            }
            .onChange(of: communityViewModel.selectedCategory) { _, _ in
                communityViewModel.isSortExpanded = false
                communityViewModel.isScrolledDown = false
                communityViewModel.scrollPosition.scrollTo(edge: .top)
                Task { await communityViewModel.loadPosts() }
            }
            .onChange(of: communityViewModel.sortOption) { _, _ in
                communityViewModel.isScrolledDown = false
                communityViewModel.scrollPosition.scrollTo(edge: .top)
                Task { await communityViewModel.loadPosts() }
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
                    // 성공 시 이 모달을 닫고, 커뮤니티 탭의 실제 네비게이션 스택에 상세 화면을
                    // push한다 — 그래야 상세 화면에서 뒤로가기를 누르면 작성 화면이 아니라
                    // 커뮤니티 목록으로 돌아간다.
                    PostWriteFlowView(postViewModel: composePostViewModel, onPostSaved: { postId, type in
                        communityRouter.push(.postDetail(postId: postId, type: type))
                        onPostCreated()
                    })
                }
            }
    }
}

#Preview("게스트") {
    CommunityView(communityViewModel: CommunityViewModel())
        .environment(CommunityRouter())
        .environment(\.isLoggedIn, false)
}

#Preview("로그인") {
    CommunityView(communityViewModel: CommunityViewModel())
        .environment(CommunityRouter())
        .environment(\.isLoggedIn, true)
}
