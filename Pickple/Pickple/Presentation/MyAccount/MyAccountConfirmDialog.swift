//
//  MyAccountConfirmDialog.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 색상/모서리 radius/여백은 임시값
//

import SwiftUI

struct MyAccountConfirmDialog: View {
    let title: String
    var description: String? = nil
    let cancelTitle: String
    let confirmTitle: String
    let onCancel: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text(title)
                    .pickpleTypography(.title02)
                    .foregroundStyle(Color.black)

                if let description {
                    Text(description)
                        .pickpleTypography(.body02)
                        .foregroundStyle(Color.neutral50)
                        .multilineTextAlignment(.center)
                }
            }

            HStack(spacing: 8) {
                Button(action: onCancel) {
                    Text(cancelTitle)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.neutral40)
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(Color.neutral10)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Button(action: onConfirm) {
                    Text(confirmTitle)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(24)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 40)
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.4).ignoresSafeArea()
        MyAccountConfirmDialog(
            title: "정말 탈퇴하시나요?",
            description: "탈퇴하시면 지금까지의 모든 데이터가\n날라가고 다시는 볼 수 없어요",
            cancelTitle: "취소",
            confirmTitle: "나가기",
            onCancel: {},
            onConfirm: {}
        )
    }
}
