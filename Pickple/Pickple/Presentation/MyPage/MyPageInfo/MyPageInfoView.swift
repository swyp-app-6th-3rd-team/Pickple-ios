//
//  MyPageInfoView.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//

import SwiftUI

struct MyPageInfoView: View {
    var isLoggedIn: Bool = true
    var onTapGrade: () -> Void = {}
    var onTapBadge: () -> Void = {}

    var body: some View {

        VStack(spacing: 0) {
            HStack {
                Text(MyPageStrings.infoSectionTitle)
                    .pickpleTypography(.body02)
                    .foregroundStyle(Color.neutral40)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            VStack(spacing: 0) {
                MyPageInfoRow(iconName: "PickpleMyGrade", title: MyPageStrings.grade, action: onTapGrade)

                MyPageInfoRow(iconName: "PickpleMyBadge", title: MyPageStrings.badge, action: onTapBadge)
            }
            // 게스트는 명세대로 나의 등급/나의 뱃지 진입점 클릭을 제한한다.
            .disabled(!isLoggedIn)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

        }
        .background(Color.white)
    }
}

#Preview {
    MyPageInfoView()
}
