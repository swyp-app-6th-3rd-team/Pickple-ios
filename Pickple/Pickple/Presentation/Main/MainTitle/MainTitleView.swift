//
//  MainTitleView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 배너 텍스트/탭 동작은 임시값(연결 로직 미정)

import SwiftUI

struct MainTitleView: View {
    @Binding var isOn: Bool
    var hasUnreadNotification: Bool = true

    var body: some View {
        HStack(spacing: 8) {
            Image("PickpleTitle")
                .padding(.leading, 20)
            
            Spacer()
            
            MainToggleButton(isOn: $isOn, onTitle: "AB", offTitle: "찬반")

            Spacer()
            
            Button(action: {}) {
                ZStack(alignment: .topTrailing) {
                    Image("PickpleAlertOff")
                        .foregroundStyle(Color.neutral100)

                }
            }
            .padding(.trailing, 20)
        }
        .frame(maxWidth: .infinity, minHeight: 56)
    }
}

#Preview {
    @Previewable @State var isOn = false
    MainTitleView(isOn: $isOn)
}
