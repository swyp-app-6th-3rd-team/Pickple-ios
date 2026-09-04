//
//  BadgeMissionProgressRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

struct BadgeMissionProgressRow: View {
    let mission: BadgeMissionProgress

    var body: some View {
        HStack(spacing: 8) {
            Text(mission.title)
                .pickpleTypography(.body02)
                .foregroundStyle(Color.neutral80)

            Spacer()

            Text("\(mission.current)/\(mission.target)")
                .pickpleTypography(.body02)
                .foregroundStyle(Color.neutral30)
        }
    }
}
