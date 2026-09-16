//
//  MyPageExtra.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//
// 1차 점검 완료 - 9월 13일


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
                
                MyPageInfoRow(iconName: "PickplePrivate", title: MyPageStrings.privatePolicy, url: MyPageStrings.privacy)

                MyPageInfoRow(iconName: "PickpleNote", title: MyPageStrings.terms, url: MyPageStrings.ToU)

                MyPageInfoRow(iconName: "PickpleInfo", title: MyPageStrings.version, url: MyPageStrings.versionInfoURL)
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
