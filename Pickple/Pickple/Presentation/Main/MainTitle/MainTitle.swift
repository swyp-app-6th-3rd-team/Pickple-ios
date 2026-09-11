//
//  MainTitleView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 배너 텍스트/탭 동작은 임시값(연결 로직 미정)

import SwiftUI

struct MainTitle: View {
    @Binding var isOn: Bool
    var hasUnreadNotification: Bool = true
    
    var body: some View {
        ZStack(alignment: .center) {
            
            PickpleGNB(leading: .image(Image("PickpleTitle")),
                       center: .none,
                       trailing: .button(icon: Image("PickpleAlertOff"), action: { /* 알림 기능 미구현 */ })
            )
            
            MainToggleButton(isOn: $isOn, onTitle: MainStrings.abToggleOnTitle, offTitle: MainStrings.abToggleOffTitle)
        }
        .frame(maxWidth: .infinity, minHeight: 56)
    }
}

#Preview {
    @Previewable @State var isOn = false
    MainTitle(isOn: $isOn)
}
