//
//  MyBadgeUnlockConditionSheet.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 여백/폰트 크기는 임시값
//

import SwiftUI

struct MyBadgeUnlockConditionSheet: View {
    let badge: MyBadge
    let onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                Text(badge.title)
                    .pickpleTypography(.title01)
                    .foregroundStyle(Color.neutral100)
                
                Image(badge.iconOffName)
                    .resizable()
                    .frame(width: 87, height: 82)
                
                Text(badge.unlockCondition)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.neutral100)
                    .multilineTextAlignment(.center)
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
            MyBadgeUnlockConditionSheet(
                badge: MyBadge(
                    id: UUID(),
                    title: "첫 PICK",
                    iconOnName: "PickpleBadgeFirstPickOn",
                    iconOffName: "PickpleBadgeFirstPickOff",
                    isUnlocked: false,
                    unlockCondition: "이 뱃지를 해제하려면\n누적 투표 10회를 달성하세요."
                ),
                onConfirm: {}
            )
        }
}
