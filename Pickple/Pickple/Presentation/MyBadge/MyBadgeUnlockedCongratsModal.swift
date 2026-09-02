//
//  MyBadgeUnlockedCongratsModal.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 여백/폰트 크기는 임시값
//

import SwiftUI

struct MyBadgeUnlockedCongratsModal: View {
    let badge: MyBadge
    let onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                Text("새로운 뱃지가 해제됐어요!")
                    .pickpleTypography(.title01)
                    .foregroundStyle(Color.neutral100)

                Image(badge.iconOnName)
                    .resizable()
                    .frame(width: 87, height: 82)

                Text(badge.title)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.neutral100)
            }

            Button(action: onConfirm) {
                Text("확인")
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 36)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            MyBadgeUnlockedCongratsModal(
                badge: MyBadge(
                    id: UUID(),
                    title: "투표 폭주기관차",
                    iconOnName: "PickpleBadgeRampageOn",
                    iconOffName: "PickpleBadgeRampageOff",
                    isUnlocked: true,
                    isNewlyUnlocked: true,
                    unlockCondition: ""
                ),
                onConfirm: {}
            )
        }
}
