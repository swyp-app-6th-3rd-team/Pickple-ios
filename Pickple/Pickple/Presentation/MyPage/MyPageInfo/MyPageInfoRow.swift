//
//  MyPageInfoRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//

import SwiftUI

struct MyPageInfoRow: View {
    let iconName: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                HStack(spacing: 10) {
                    Image(iconName)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.neutral40)

                    Text(title)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.black)
                }

                Spacer()

                Image("PickpleArrowRight")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(Color.neutral40)
            }
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    MyPageInfoRow(iconName: "PickpleMyGrade", title: "나의 등급", action: {})
}
