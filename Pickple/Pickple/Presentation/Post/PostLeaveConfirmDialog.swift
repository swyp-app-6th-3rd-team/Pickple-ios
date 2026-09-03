//
//  PostLeaveConfirmDialog.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 여백/폰트 크기는 임시값

import SwiftUI

// 작성 중 뒤로가기를 누르면 뜨는 "작성 중인 내용이 있어요" 확인 모달.
struct PostLeaveConfirmDialog: View {
    let onCancel: () -> Void
    let onLeave: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text(PostViewStrings.leaveConfirmTitle)
                    .pickpleTypography(.title01)
                    .foregroundStyle(Color.neutral100)

                Text(PostViewStrings.leaveConfirmDescription)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.neutral70)
                    .multilineTextAlignment(.center)
            }

            HStack(spacing: 8) {
                Button(action: onCancel) {
                    Text(PostViewStrings.leaveConfirmCancel)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.neutral50)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(Color.neutral5)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Button(action: onLeave) {
                    Text(PostViewStrings.leaveConfirmConfirm)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(Color.neutral100)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(24)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.4).ignoresSafeArea()
        PostLeaveConfirmDialog(onCancel: {}, onLeave: {})
    }
}
