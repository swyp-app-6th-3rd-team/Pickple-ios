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
                Text("기타")
                    .pickpleTypography(.body02)
                    .foregroundStyle(Color.neutral40)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            VStack(spacing: 0) {
                MyPageInfoRow(iconName: "PickpleUser", title: "계정 관리", action: onTapAccount)

                // TODO: 약관 및 정책·버전 정보 화면 미정 — 화면 나오면 연결
                MyPageInfoRow(iconName: "PickpleNote", title: "약관 및 정책", action: {})

                MyPageInfoRow(iconName: "PickpleInfo", title: "버전 정보", action: {})
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
