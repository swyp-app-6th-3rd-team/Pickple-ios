//
//  MyAccountView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요
//  - 구분선(Rectangle) 두께 4pt / Color.neutral5는 임시값, Figma 확인 후 조정
//  - 폰트/타이포그래피는 PickpleGNB·MyPageInfoRow가 쓰는 기존 스타일 그대로 사용 중 — 이 화면 전용 스펙 확인 필요
//

import SwiftUI

struct MyAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showsLogoutConfirm = false
    @State private var showsLeaveConfirm = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                PickpleGNB(
                    leading: .button(icon: Image("PickpleArrowLeft"), action: { dismiss() }),
                    center: .text(MyAccountStrings.title),
                    trailing: .none
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
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { showsLogoutConfirm = false }

                MyAccountConfirmDialog(
                    title: MyAccountStrings.logoutConfirmTitle,
                    cancelTitle: MyAccountStrings.cancel,
                    confirmTitle: MyAccountStrings.logout,
                    onCancel: { showsLogoutConfirm = false },
                    onConfirm: {
                        showsLogoutConfirm = false
                        //TODO: 실제 로그아웃 처리 연결 필요
                    }
                )
            }

            if showsLeaveConfirm {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { showsLeaveConfirm = false }

                MyAccountConfirmDialog(
                    title: MyAccountStrings.leaveConfirmTitle,
                    description: MyAccountStrings.leaveConfirmDescription,
                    cancelTitle: MyAccountStrings.cancel,
                    confirmTitle: MyAccountStrings.leaveConfirmButton,
                    onCancel: { showsLeaveConfirm = false },
                    onConfirm: {
                        showsLeaveConfirm = false
                        //TODO: 실제 탈퇴 처리 연결 필요
                    }
                )
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MyAccountView()
}
