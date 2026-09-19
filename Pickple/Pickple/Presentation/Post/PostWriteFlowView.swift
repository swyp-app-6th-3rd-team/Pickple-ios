//
//  PostWriteFlowView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료 - 9월 12일

import SwiftUI

// 글 유형이 정해진 뒤의 작성 화면. 유형별 입력을 전부 한 화면에 모아서 보여주고,
// 상단 게이지가 필수 항목 채움 정도를 보여준다.
struct PostWriteFlowView: View {
    let postViewModel: PostViewModel
    // 게시/수정 성공 시 호출 — 호출부가 이 화면을 어떻게 닫고 어디로 보여줄지 결정한다
    // (여기서 직접 상세 화면을 push하면, 그 화면에서 뒤로가기를 눌렀을 때 이 작성 화면으로
    // 되돌아와버리는 문제가 있었다).
    var onPostSaved: (Int, VoteType) -> Void = { _, _ in }
    @Environment(\.dismiss) private var dismiss

    @State private var isCategoryExpanded = false
    @State private var showsLeaveConfirm = false
    @State private var showsFailureToast = false

    private let categoryOptions = PostViewStrings.categoryOptions

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 0) {
                PickpleGNB(
                    leading: .button(icon: Image("PickpleArrowLeft"), action: handleBack),
                    center: .text(postViewModel.gnbTitle),
                    trailing: .none,
                    bar: false
                )

                // 일반 게시글은 필드가 3개뿐이고 전부 기본으로 보이므로, 순차 공개도 게이지도 필요
                // 없다. 수정 모드도 모든 필드가 이미 채워진 채로 시작해서(일부는 잠긴 채) "채워나가는"
                // 진행률 개념이 안 맞아 게이지를 숨긴다.
                if postViewModel.selectedType != .text && !postViewModel.isEditing {
                    ProgressView(value: Double(postViewModel.requiredFieldsFilledCount), total: Double(postViewModel.requiredFieldsTotalCount))
                        .progressViewStyle(LinearProgressViewStyle(tint: Color.yellow60))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)

                        .animation(.easeInOut, value: postViewModel.requiredFieldsFilledCount)
                }

                ScrollViewReader { scrollProxy in
                    ScrollView {
                        PostWriteFlowStepContent(
                            postViewModel: postViewModel,
                            isCategoryExpanded: $isCategoryExpanded,
                            categoryOptions: categoryOptions
                        )
                        .zIndex(isCategoryExpanded ? 1 : 0)
                        .padding(.top, 28)
                        .padding(.horizontal, 20)
                    }
                    // "설명"(TextEditor) 필드는 박스가 큰데(180pt) 커서 위치를 계속
                    // 따라가는 iOS 기본 스크롤이 어색해서, 포커스되는 순간 필드 박스 자체
                    // 기준으로 한 번만 스크롤한다 — ScrollToFieldKey는 그 필드에서
                    // ForAgainstPostFieldSectionView 등 중간 화면들을 거치지 않고 바로 올라온다.
                    .onPreferenceChange(ScrollToFieldKey.self) { fieldID in
                        guard let fieldID else { return }
                        withAnimation {
                            scrollProxy.scrollTo(fieldID, anchor: .top)
                        }
                    }
                }
                // 배경(Color.white)에 onTapGesture를 걸었더니 ScrollView가 빈 공간까지
                // 포함해서 자기 프레임 전체를 스크롤 제스처용으로 히트테스트하고 있어서
                // 터치가 배경까지 안 내려왔다 — dismissKeyboardOnTap()처럼 simultaneousGesture로
                // ScrollView 자체에 걸면 스크롤을 막지 않으면서 탭도 같이 인식된다.
                .simultaneousGesture(
                    TapGesture().onEnded {
                        if isCategoryExpanded {
                            withAnimation(.spring()) {
                                isCategoryExpanded = false
                            }
                        }
                    }
                )
                // 포커스된 입력 필드가 키보드에 가려지지 않고 키보드 위 16pt 지점에 보이게 한다.
                // 필드마다 흩어진 FocusState를 하나로 합치지 않고, ScrollView 아래쪽에 키보드
                // 높이만큼 safeAreaInset을 예약해서 그 영역을 "스크롤 불가 영역"으로 만드는
                // 식이라, 개별 필드 로직(검증/글자수 제한/순차 공개 등)은 전혀 안 건드린다 —
                // iOS가 이미 갖고 있는 "포커스된 입력창을 보이는 영역 안으로 스크롤" 동작이
                // 이 여백을 기준으로 알아서 동작한다.
                .keyboardAwareBottomInset()

                // 필드가 순차 공개되면서 게시 버튼이 계속 밀려 내려가지 않게, 스크롤 영역
                // 밖으로 빼서 화면 하단에 고정한다.
                PostWriteFlowButtonRow(
                    title: postViewModel.isEditing ? PostViewStrings.submitEdit : PostViewStrings.submit,
                    isEnabled: postViewModel.canSubmit,
                    onSubmit: handleSubmit
                )
                .padding(.horizontal, 20)
            }
            

            if showsLeaveConfirm {
                PickpleDialogOverlay(onTapDismiss: { showsLeaveConfirm = false }) {
                    PickpleConfirmDialog(
                        title: PostViewStrings.leaveConfirmTitle,
                        description: PostViewStrings.leaveConfirmDescription,
                        cancelTitle: PostViewStrings.leaveConfirmCancel,
                        confirmTitle: PostViewStrings.leaveConfirmConfirm,
                        onCancel: { showsLeaveConfirm = false },
                        onConfirm: { dismiss() }
                    )
                }
            }
        }
        .pickpleToast(isPresented: $showsFailureToast, message: postViewModel.isEditing ? PostViewStrings.submitEditFailedToast : PostViewStrings.submitFailedToast)
        .navigationBarBackButtonHidden(true)
        .restoresSwipeBackGesture()
        .toolbar(.hidden, for: .tabBar)
        // 이 화면은 커뮤니티 탭에서 .fullScreenCover로도 뜨는데, 모달 프레젠테이션은 앱
        // 루트와 별개의 뷰 계층이라 루트에 건 dismissKeyboardOnTap()이 여기까지 전파되지
        // 않는다 — 이 화면 자체에도 걸어준다.
        .dismissKeyboardOnTap()
    }

    private func handleBack() {
        if postViewModel.hasDraftContent {
            showsLeaveConfirm = true
        } else {
            dismiss()
        }
    }

    private func handleSubmit() {
        Task {
            await postViewModel.submitPost()
            if postViewModel.submitState == .succeeded, let postId = postViewModel.createdPostId {
                onPostSaved(postId, postViewModel.selectedType)
                dismiss()
            } else {
                showsFailureToast = true
            }
        }
    }
}

// 게시 버튼(ScrollView 밖, 화면 하단 고정)은 키보드가 뜨면 시스템이 이미 자동으로 키보드
// 위까지 밀어올려준다 — 그래서 키보드 높이를 따로 추적할 필요 없이, 그 버튼과 스크롤
// 콘텐츠 사이에 16pt 여백만 예약하면 포커스된 필드가 "버튼 위 16pt"에 보이게 된다.
private struct KeyboardAwareBottomInsetModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 16)
            }
    }
}

private extension View {
    func keyboardAwareBottomInset() -> some View {
        modifier(KeyboardAwareBottomInsetModifier())
    }
}

#Preview("찬반") {
    let viewModel = PostViewModel()
    viewModel.selectedType = .forAgainst

    return NavigationStack {
        PostWriteFlowView(postViewModel: viewModel)
    }
}

#Preview("A/B") {
    let viewModel = PostViewModel()
    viewModel.selectedType = .ab

    return NavigationStack {
        PostWriteFlowView(postViewModel: viewModel)
    }
}

#Preview("일반") {
    let viewModel = PostViewModel()
    viewModel.selectedType = .text

    return NavigationStack {
        PostWriteFlowView(postViewModel: viewModel)
    }
}
