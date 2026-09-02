//
//  MyAccountView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요
//  - 구분선(Rectangle) 두께 4pt / Color.neutral5는 임시값, Figma 확인 후 조정
//  - 폰트/타이포그래피는 PickpleGNB·MyPageInfoRow가 쓰는 기존 스타일 그대로 사용 중 — 이 화면 전용 스펙 확인 필요
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

            Rectangle()
                .frame(height: 4)
                .foregroundStyle(Color.neutral5)

            VStack(spacing: 0) {
                MyPageInfoRow(iconName: "PickpleLogout", title: "로그아웃", action: {})
                    

                MyPageInfoRow(iconName: "PickpleLeave", title: "계정탈퇴", action: {})
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            Spacer()
        }
    }
}

#Preview {
    MyAccountView()
}
