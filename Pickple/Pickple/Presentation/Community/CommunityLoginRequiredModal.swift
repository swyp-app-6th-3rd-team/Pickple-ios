//
//  CommunityLoginRequiredModal.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 여백/폰트 크기는 임시값

import SwiftUI

struct CommunityLoginRequiredModal: View {
    let onCancel: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text(CommunityStrings.loginRequiredTitle)
                    .pickpleTypography(.title01)
                    .foregroundStyle(Color.black)

                Text(CommunityStrings.loginRequiredDescription)
                    .pickpleTypography(.body02)
                    .foregroundStyle(Color.neutral40)
                    .multilineTextAlignment(.center)
            }

            HStack(spacing: 8) {
                Button(action: onCancel) {
                    Text(CommunityStrings.cancel)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.black)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(Color.neutral10)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Button(action: onConfirm) {
                    Text(CommunityStrings.login)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, minHeight: 52)
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
        CommunityLoginRequiredModal(onCancel: {}, onConfirm: {})
    }
}
