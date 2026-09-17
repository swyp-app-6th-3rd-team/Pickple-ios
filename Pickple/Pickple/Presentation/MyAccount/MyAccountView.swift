//
//  MyAccountView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료 - 9월 13일

import SwiftUI

struct MyAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appLogout) private var appLogout
    @Environment(\.appDeleteAccount) private var appDeleteAccount
    @Environment(\.isLoggedIn) private var isLoggedIn
    @State private var showsLogoutConfirm = false
    @State private var showsLeaveConfirm = false
    @State private var deleteAccountErrorMessage: String?

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 0) {
                PickpleGNB(
                    leading: .button(icon: Image("PickpleArrowLeft"), action: { dismiss() }),
                    center: .text(MyAccountStrings.title),
                    trailing: .none,
                    bar: false
                )

                Rectangle()
                    .frame(height: 4)
                    .foregroundStyle(Color.neutral5)

                VStack(spacing: 0) {
                    MyPageInfoRow(iconName: "PickpleLogout", title: MyAccountStrings.logout) {
                        showsLogoutConfirm = true
                    }

                    MyPageInfoRow(iconName: "PickpleLeave", title: MyAccountStrings.leave) {
                        showsLeaveConfirm = true
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)

                Spacer()
            }

            if showsLogoutConfirm {
                PickpleDialogOverlay(onTapDismiss: { showsLogoutConfirm = false }) {
                    PickpleConfirmDialog(
                        title: MyAccountStrings.logoutConfirmTitle,
                        cancelTitle: MyAccountStrings.cancel,
                        confirmTitle: MyAccountStrings.logout,
                        onCancel: { showsLogoutConfirm = false },
                        onConfirm: {
                            showsLogoutConfirm = false
                            Task { await appLogout() }
                        }
                    )
                }
            }

            if showsLeaveConfirm {
                PickpleDialogOverlay(onTapDismiss: { showsLeaveConfirm = false }) {
                    PickpleConfirmDialog(
                        title: MyAccountStrings.leaveConfirmTitle,
                        description: MyAccountStrings.leaveConfirmDescription,
                        cancelTitle: MyAccountStrings.cancel,
                        confirmTitle: MyAccountStrings.leaveConfirmButton,
                        onCancel: { showsLeaveConfirm = false },
                        onConfirm: {
                            showsLeaveConfirm = false
                            // 게스트는 지울 실제 계정이 없어서, 탈퇴를 로그아웃과 동일하게 처리해
                            // 게스트 세션만 종료한다(서버 탈퇴 API는 인증된 계정 대상이라 게스트로
                            // 호출하면 실패한다).
                            if isLoggedIn {
                                Task {
                                    do {
                                        try await appDeleteAccount()
                                    } catch {
                                        deleteAccountErrorMessage = error.localizedDescription
                                    }
                                }
                            } else {
                                Task { await appLogout() }
                            }
                        }
                    )
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .alert(MyAccountStrings.deleteAccountFailedTitle, isPresented: Binding(
            get: { deleteAccountErrorMessage != nil },
            set: { isPresented in if !isPresented { deleteAccountErrorMessage = nil } }
        )) {
            Button(MyAccountStrings.confirm, role: .cancel) {}
        } message: {
            Text(deleteAccountErrorMessage ?? "")
        }
    }
}

#Preview {
    MyAccountView()
}
