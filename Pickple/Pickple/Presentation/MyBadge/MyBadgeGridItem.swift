//
//  MyBadgeGridItem.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

struct MyBadgeGridItem: View {
    let badge: MyBadge
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(badge.isUnlocked ? badge.iconOnName : badge.iconOffName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)

                Text(badge.title)
                    .pickpleTypography(.caption)
                    .foregroundStyle(badge.isUnlocked ? Color.black : Color.neutral40)
            }
        }
    }
}

#Preview {
    HStack {
        MyBadgeGridItem(
            badge: MyBadge(id: UUID(), title: "첫 PICK", iconOnName: "PickpleBadgeFirstPickOn", iconOffName: "PickpleBadgeFirstPickOff", isUnlocked: true, unlockCondition: ""),
            action: {}
        )
        MyBadgeGridItem(
            badge: MyBadge(id: UUID(), title: "PICK 중독", iconOnName: "PickpleBadgeAddictOn", iconOffName: "PickpleBadgeAddictOff", isUnlocked: false, unlockCondition: ""),
            action: {}
        )
    }
}
