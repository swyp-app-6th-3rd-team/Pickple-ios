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
                    center: .text("계정관리"),
                    trailing: .none
                )

                Rectangle()
                    .frame(height: 4)
                    .foregroundStyle(Color.neutral5)

                VStack(spacing: 0) {
                    MyPageInfoRow(iconName: "PickpleLogout", title: "로그아웃") {
                        showsLogoutConfirm = true
                    }

                    MyPageInfoRow(iconName: "PickpleLeave", title: "계정탈퇴") {
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
                    title: "로그아웃 할까요?",
                    cancelTitle: "취소",
                    confirmTitle: "로그아웃",
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
                    title: "정말 탈퇴하시나요?",
                    description: "탈퇴하시면 지금까지의 모든 데이터가\n날라가고 다시는 볼 수 없어요",
                    cancelTitle: "취소",
                    confirmTitle: "나가기",
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
