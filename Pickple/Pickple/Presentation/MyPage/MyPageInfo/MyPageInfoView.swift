//
//  MyPageInfoView.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//

import SwiftUI

struct MyPageInfoView: View {
    var onTapGrade: () -> Void = {}
    var onTapBadge: () -> Void = {}

    var body: some View {

        VStack(spacing: 0) {
            HStack {
                Text("마이페이지")
                    .pickpleTypography(.body02)
                    .foregroundStyle(Color.neutral40)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            VStack(spacing: 0) {
                MyPageInfoRow(iconName: "PickpleMyGrade", title: "나의 등급", action: onTapGrade)

                MyPageInfoRow(iconName: "PickpleMyBadge", title: "나의 뱃지", action: onTapBadge)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

        }
        .background(Color.white)
    }
}

#Preview {
    MyPageInfoView()
}
