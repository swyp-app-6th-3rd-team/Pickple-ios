//
//  PostWriteFlowView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 여백/간격은 임시값

import SwiftUI

// 글 유형이 정해진 뒤의 단계별 작성 화면(찬반 2단계 / A-B 3단계 / 일반 1단계).
struct PostWriteFlowView: View {
    @ObservedObject var postViewModel: PostViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var isCategoryExpanded = false
    @State private var showsLeaveConfirm = false
    @State private var showsFailureToast = false
    @State private var navigatesToDetail = false

    private let categoryOptions = PostViewStrings.categoryOptions

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                PickpleGNB(
                    leading: .button(icon: Image("PickpleArrowLeft"), action: handleBack),
                    center: .text(postViewModel.gnbTitle),
                    trailing: .none
                )

                if postViewModel.totalSteps > 1 {
                    PickpleProgressBar(totalSteps: postViewModel.totalSteps, currentIndex: postViewModel.currentIndex)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                }

                ScrollView {
                    PostWriteFlowStepContent(
                        postViewModel: postViewModel,
                        isCategoryExpanded: $isCategoryExpanded,
                        categoryOptions: categoryOptions
                    )
                    .padding(.top, 32)
                    .zIndex(isCategoryExpanded ? 1 : 0)
                }

                PostWriteFlowButtonRow(
                    showsPrevious: postViewModel.currentIndex > 0,
                    primaryTitle: postViewModel.isLastStep ? PostViewStrings.submit : PostViewStrings.next,
                    isPrimaryEnabled: postViewModel.isCurrentStepValid,
                    onPrevious: { postViewModel.moveToPreviousStep() },
                    onPrimary: handlePrimaryAction
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
        .pickpleToast(isPresented: $showsFailureToast, message: PostViewStrings.submitFailedToast)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigatesToDetail) {
            // TODO: 방금 게시한 글을 바로 보여주려면 실제 등록된 게시글 정보 연동 필요 — 지금은 유형에 맞는 Mock 상세로 이동
            PostDetailView(voteType: postViewModel.selectedType, showsSuccessToastOnAppear: true)
        }
    }

    private func handleBack() {
        if postViewModel.currentIndex > 0 {
            postViewModel.moveToPreviousStep()
        } else if postViewModel.hasDraftContent {
            showsLeaveConfirm = true
        } else {
            dismiss()
        }
    }

    private func handlePrimaryAction() {
        if postViewModel.isLastStep {
            Task {
                await postViewModel.submitPost()
                if postViewModel.submitState == .succeeded {
                    navigatesToDetail = true
                } else {
                    showsFailureToast = true
                }
            }
        } else {
            postViewModel.moveToNextStep()
        }
    }
}

#Preview {
    NavigationStack {
        PostWriteFlowView(postViewModel: PostViewModel())
    }
}
