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
            badge: MyBadge(id: UUID(), title: "투표 꿈나무", iconOnName: "PickpleBadgeFirstPickOn", iconOffName: "PickpleBadgeFirstPickOff", isUnlocked: true, isNewlyUnlocked: false, unlockCondition: ""),
            action: {}
        )
        MyBadgeGridItem(
            badge: MyBadge(id: UUID(), title: "투표 중독자", iconOnName: "PickpleBadgeAddictOn", iconOffName: "PickpleBadgeAddictOff", isUnlocked: false, isNewlyUnlocked: false, unlockCondition: ""),
            action: {}
        )
    }
}
