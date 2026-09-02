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
                HStack(spacing: 4) {
                    Image("PickpleLevelBadge\(level)")
                        .resizable()
                        .frame(width: 16, height: 16)

                    Text("LV.\(level)")
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.black)
                }

                Text(description)
                    .pickpleTypography(.caption)
                    .foregroundStyle(Color.neutral50)
            }

            Spacer()
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    MyGradeRow(level: 2, description: "누적 200P + 투표 20회")
}
