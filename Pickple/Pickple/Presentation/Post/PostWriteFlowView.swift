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

    @State private var currentIndex = 0
    @State private var isCategoryExpanded = false
    @State private var showsLeaveConfirm = false
    @State private var showsFailureToast = false
    @State private var navigatesToDetail = false

    private let categoryOptions = ["패션/잡화", "전자제품", "화장품/뷰티", "생활용품", "기타"]

    private var gnbTitle: String {
        switch postViewModel.selectedType {
        case .forAgainst: return PostViewStrings.forAgainstWriteTitle
        case .compare: return PostViewStrings.compareWriteTitle
        case .text: return PostViewStrings.textWriteTitle
        }
    }

    private var isLastStep: Bool {
        currentIndex >= postViewModel.totalSteps - 1
    }

    private var isCurrentStepValid: Bool {
        currentIndex == 0 ? postViewModel.isStepOneValid : postViewModel.canSubmit
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                PickpleGNB(
                    leading: .button(icon: Image("PickpleArrowLeft"), action: handleBack),
                    center: .text(gnbTitle),
                    trailing: .none
                )

                if postViewModel.totalSteps > 1 {
                    PickpleProgressBar(totalSteps: postViewModel.totalSteps, currentIndex: currentIndex)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                }

                ScrollView {
                    stepContent
                        .padding(.top, 32)
                        .zIndex(isCategoryExpanded ? 1 : 0)
                }

                buttonRow
            }

            if showsLeaveConfirm {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { showsLeaveConfirm = false }

                PostLeaveConfirmDialog(
                    onCancel: { showsLeaveConfirm = false },
                    onLeave: { dismiss() }
                )
            }
        }
        .pickpleToast(isPresented: $showsFailureToast, message: PostViewStrings.submitFailedToast)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigatesToDetail) {
            // TODO: 방금 게시한 글을 바로 보여주려면 실제 등록된 게시글 정보 연동 필요 — 지금은 Mock 상세로 이동
            PostDetailView(showsSuccessToastOnAppear: true)
        }
    }

    @ViewBuilder
    private var stepContent: some View {
        switch postViewModel.selectedType {
        case .forAgainst:
            if currentIndex == 0 {
                ForAgainstStepOneView(postViewModel: postViewModel, isCategoryExpanded: $isCategoryExpanded, categoryOptions: categoryOptions)
            } else {
                ForAgainstStepTwoView(postViewModel: postViewModel)
            }
        case .compare:
            if currentIndex == 0 {
                CompareStepOneView(postViewModel: postViewModel, isCategoryExpanded: $isCategoryExpanded, categoryOptions: categoryOptions)
            } else if currentIndex == 1 {
                CompareStepTwoView(postViewModel: postViewModel)
            } else {
                CompareStepThreeView(postViewModel: postViewModel)
            }
        case .text:
            TextStepOneView(postViewModel: postViewModel, isCategoryExpanded: $isCategoryExpanded, categoryOptions: categoryOptions)
        }
    }

    private var buttonRow: some View {
        HStack(spacing: 8) {
            if currentIndex > 0 {
                Button(action: { currentIndex -= 1 }) {
                    Text(PostViewStrings.previous)
                }
                .buttonStyle(.pickple(._default, 52))
            }

            Button(action: handlePrimaryAction) {
                Text(isLastStep ? PostViewStrings.submit : PostViewStrings.next)
            }
            .buttonStyle(.pickple(isCurrentStepValid ? .enabled : .disabled, 52))
            .disabled(!isCurrentStepValid)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }

    private func handleBack() {
        if currentIndex > 0 {
            currentIndex -= 1
        } else if postViewModel.hasDraftContent {
            showsLeaveConfirm = true
        } else {
            dismiss()
        }
    }

    private func handlePrimaryAction() {
        if isLastStep {
            Task {
                await postViewModel.submitPost()
                if postViewModel.submitState == .succeeded {
                    navigatesToDetail = true
                } else {
                    showsFailureToast = true
                }
            }
        } else {
            currentIndex += 1
        }
    }
}

#Preview {
    NavigationStack {
        PostWriteFlowView(postViewModel: PostViewModel())
    }
}
