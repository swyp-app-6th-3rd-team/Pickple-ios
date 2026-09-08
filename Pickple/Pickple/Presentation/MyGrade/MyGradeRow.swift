//
//  MyGradeRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

struct MyGradeRow: View {
    let grade: GradeCriteria

    private var description: String {
        MyGradeStrings.requirementDescription(point: grade.requiredPoint, voteCount: grade.requiredVoteCount)
    }

    var body: some View {
        HStack(spacing: 12) {
            Image("PickpleGradeCharacter\(grade.level)")
                .resizable()
                .frame(width: 48, height: 48)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 2) {
                    Image("PickpleLevelBadge\(grade.level)")
                        .resizable()
                        .frame(width: 16, height: 16)

                    Text("LV.\(grade.level)")
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
    MyGradeRow(grade: GradeCriteria(level: 2, name: "LV.2", requiredPoint: 200, requiredVoteCount: 20))
}
