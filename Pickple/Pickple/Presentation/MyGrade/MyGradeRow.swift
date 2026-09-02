//
//  MyGradeRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

struct MyGradeRow: View {
    let level: Int
    let description: String

    var body: some View {
        HStack(spacing: 12) {
            Image("PickpleGradeCharacter\(level)")
                .resizable()
                .frame(width: 48, height: 48)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 2) {
                    Image("PickpleLevelBadge\(level)")
                        .resizable()
                        .frame(width: 16, height: 16)

                    Text("LV.\(level)")
                        .pickpleTypography(.label)
                        .foregroundStyle(Color.black)
                }

                Text(description)
                    .pickpleTypography(.body02)
                    .foregroundStyle(Color.neutral40)
            }

            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
    }
}

#Preview {
    MyGradeRow(level: 2, description: "누적 200P + 투표 20회")
}
