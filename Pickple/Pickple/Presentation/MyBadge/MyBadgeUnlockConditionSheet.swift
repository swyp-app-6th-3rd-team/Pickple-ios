//
//  MyBadgeUnlockConditionSheet.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//
// 1차 점검 완료 - 9월 13일

import SwiftUI

struct MyBadgeUnlockConditionSheet: View {
    let badge: MyBadge
    let onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                Text(badge.title)
                    .pickpleTypography(.title01)
                    .foregroundStyle(Color.black)
                
                Image(badge.iconOffName)
                    .resizable()
                    .frame(width: 87, height: 82)
                
                Text(badge.unlockCondition)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.black)
                    .multilineTextAlignment(.center)
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
        .presentationDetents([.height(324)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            MyBadgeUnlockConditionSheet(
                badge: MyBadge(
                    id: UUID(),
                    title: "첫 PICK",
                    iconOnName: "PickpleBadgeFirstPickOn",
                    iconOffName: "PickpleBadgeFirstPickOff",
                    isUnlocked: false,
                    isNewlyUnlocked: false,
                    unlockCondition: "이 뱃지를 해제하려면\n누적 투표 10회를 달성하세요."
                ),
                onConfirm: {}
            )
        }
}
