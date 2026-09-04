//
//  MyPageExtra.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//

import SwiftUI

struct MyPageExtraView: View {
    var onTapAccount: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(MyPageStrings.extraSectionTitle)
                    .pickpleTypography(.body02)
                    .foregroundStyle(Color.neutral40)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            VStack(spacing: 0) {
                MyPageInfoRow(iconName: "PickpleUser", title: MyPageStrings.account, action: onTapAccount)

                // TODO: 약관 및 정책·버전 정보 화면 미정 — 화면 나오면 연결
                MyPageInfoRow(iconName: "PickpleNote", title: MyPageStrings.terms, action: {})

                MyPageInfoRow(iconName: "PickpleInfo", title: MyPageStrings.version, action: {})
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

        }
        .background(Color.white)
    }
}

#Preview {
    MyPageExtraView()
}
