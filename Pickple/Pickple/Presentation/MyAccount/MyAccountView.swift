//
//  MyAccountView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

struct MyAccountView: View {
    var body: some View {
        VStack(spacing: 0) {
            PickpleGNB(
                leading: .button(icon: Image("PickpleArrowLeft"), action: {}),
                center: .text("계정관리"),
                trailing: .none
            )

            Divider()

            VStack(spacing: 0) {
                MyPageInfoRow(iconName: "PickpleLogout", title: "로그아웃", action: {})

                MyPageInfoRow(iconName: "PickpleLeave", title: "계정탈퇴", action: {})
            }
            .padding(.horizontal, 20)

            Spacer()
        }
    }
}

#Preview {
    MyAccountView()
}
