//
//  PickpleConfirmDialog.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료 - 9월 12일
// 미활성 버튼 색상 미지정 f1f1f5

import SwiftUI

// 타이틀 + 설명 + 취소/확인 버튼 두 개짜리 중앙 모달.
struct PickpleConfirmDialog: View {
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
                    .pickpleTypography(.title01)
                    .foregroundStyle(Color.black)

                if let description {
                    Text(description)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.neutral70)
                        .multilineTextAlignment(.center)
                }
            }

            HStack(spacing: 8) {
                Button(action: onCancel) {
                    Text(cancelTitle)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.neutral50)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(Color.neutral5) //버튼 색 미정
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Button(action: onConfirm) {
                    Text(confirmTitle)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
        .padding(.bottom, 24)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview("설명 있음") {
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

#Preview("설명 없음") {
    ZStack {
        Color.black.opacity(0.4).ignoresSafeArea()
        PickpleConfirmDialog(
            title: "로그아웃 하시겠습니까?",
            cancelTitle: "취소",
            confirmTitle: "로그아웃",
            onCancel: {},
            onConfirm: {}
        )
        .padding(.horizontal, 40)
    }
}
