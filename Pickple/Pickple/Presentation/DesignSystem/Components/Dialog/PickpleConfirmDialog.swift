//
//  PickpleConfirmDialog.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 여백/폰트 크기는 임시값

import SwiftUI

// 타이틀 + 설명 + 취소/확인 버튼 두 개짜리 중앙 모달. 화면마다 좌우 여백은 호출부에서 준다.
struct PickpleConfirmDialog: View {
    let title: String
    let description: String
    let cancelTitle: String
    let confirmTitle: String
    let onCancel: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text(title)
                    .pickpleTypography(.title01)
                    .foregroundStyle(Color.neutral100)

                Text(description)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.neutral70)
                    .multilineTextAlignment(.center)
            }

            HStack(spacing: 8) {
                Button(action: onCancel) {
                    Text(cancelTitle)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.neutral50)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(Color.neutral5)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Button(action: onConfirm) {
                    Text(confirmTitle)
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
        PickpleConfirmDialog(
            title: "게시글을 삭제할까요?",
            description: "게시글을 삭제하면 다시는\n볼 수 없어요",
            cancelTitle: "취소",
            confirmTitle: "삭제",
            onCancel: {},
            onConfirm: {}
        )
        .padding(.horizontal, 40)
    }
}
