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
                // 게스트는 계정 관리 진입 시 로그인 유도 다이얼로그로 연결한다(onTapAccount에서 분기).
                MyPageInfoRow(iconName: "PickpleUser", title: MyPageStrings.account, action: onTapAccount)

                // TODO: 약관 및 정책·버전 정보 화면 미정 — 화면 나오면 연결
                MyPageInfoRow(iconName: "PickpleNote", title: MyPageStrings.terms, url: MyPageStrings.ToU, action: {})

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
