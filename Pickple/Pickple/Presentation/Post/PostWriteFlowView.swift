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

    private let categoryOptions = ["패션/잡화", "전자제품", "화장품/뷰티", "생활용품", "기타"]

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
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { showsLeaveConfirm = false }

                PostLeaveConfirmDialog(
                    onCancel: { showsLeaveConfirm = false },
                    onLeave: { dismiss() }
                )
                .padding(.horizontal, 40)
            }
        }
        .pickpleToast(isPresented: $showsFailureToast, message: PostViewStrings.submitFailedToast)
        .navigationBarBackButtonHidden(true)
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
                    dismiss()
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

// 유형/단계에 맞는 입력 화면을 고른다.
private struct PostWriteFlowStepContent: View {
    @ObservedObject var postViewModel: PostViewModel
    @Binding var isCategoryExpanded: Bool
    let categoryOptions: [String]

    var body: some View {
        switch postViewModel.selectedType {
        case .forAgainst:
            if postViewModel.currentIndex == 0 {
                ForAgainstStepOneView(postViewModel: postViewModel, isCategoryExpanded: $isCategoryExpanded, categoryOptions: categoryOptions)
                    .padding(.horizontal, 20)
            } else {
                ForAgainstStepTwoView(postViewModel: postViewModel)
            }
        case .ab:
            if postViewModel.currentIndex == 0 {
                ABStepOneView(postViewModel: postViewModel, isCategoryExpanded: $isCategoryExpanded, categoryOptions: categoryOptions)
            } else if postViewModel.currentIndex == 1 {
                ABStepTwoView(postViewModel: postViewModel)
            } else {
                ABStepThreeView(postViewModel: postViewModel)
            }
        case .text:
            TextStepOneView(postViewModel: postViewModel, isCategoryExpanded: $isCategoryExpanded, categoryOptions: categoryOptions)
        }
    }
}

// 하단 이전/다음(또는 게시) 버튼 줄.
private struct PostWriteFlowButtonRow: View {
    let showsPrevious: Bool
    let primaryTitle: String
    let isPrimaryEnabled: Bool
    let onPrevious: () -> Void
    let onPrimary: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            if showsPrevious {
                Button(action: onPrevious) {
                    Text(PostViewStrings.previous)
                }
                .buttonStyle(.pickple(._default, 52))
            }

            Button(action: onPrimary) {
                Text(primaryTitle)
            }
            .buttonStyle(.pickple(isPrimaryEnabled ? .enabled : .disabled, 52))
            .disabled(!isPrimaryEnabled)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}
