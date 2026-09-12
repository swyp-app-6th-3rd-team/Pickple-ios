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

                ScrollView {
                    PostWriteFlowStepContent(
                        postViewModel: postViewModel,
                        isCategoryExpanded: $isCategoryExpanded,
                        categoryOptions: categoryOptions
                    )
                    .padding(.top, 28)
                    .zIndex(isCategoryExpanded ? 1 : 0)
                }
                .padding(.horizontal, 20)

                PostWriteFlowButtonRow(
                    title: postViewModel.isEditing ? PostViewStrings.submitEdit : PostViewStrings.submit,
                    isEnabled: postViewModel.canSubmit,
                    onSubmit: handleSubmit
                )
            }
            

            if showsLeaveConfirm {
                PickpleDialogOverlay(onTapDismiss: { showsLeaveConfirm = false }) {
                    PostLeaveConfirmDialog(
                        onCancel: { showsLeaveConfirm = false },
                        onLeave: { dismiss() }
                    )
                }
            }
        }
        .pickpleToast(isPresented: $showsFailureToast, message: postViewModel.isEditing ? PostViewStrings.submitEditFailedToast : PostViewStrings.submitFailedToast)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
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
