//
//  MyBadgeUnlockedCongratsModal.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//
//  1차 점검 완료 - 9월 13일

import SwiftUI

struct MyBadgeUnlockedCongratsModal: View {
    let badge: MyBadge
    let onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                Text(MyBadgeStrings.newlyUnlockedTitle)
                    .pickpleTypography(.title01)
                    .foregroundStyle(Color.black)

                Image(badge.iconOnName)
                    .resizable()
                    .frame(width: 87, height: 82)

                Text(badge.title)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.black)
            }

            Button(action: onConfirm) {
                Text(MyBadgeStrings.confirm)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 20)
        .padding(.bottom, 36)
        .presentationDetents([.height(302)])
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
