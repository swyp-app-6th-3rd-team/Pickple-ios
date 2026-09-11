//
//  MainTitleView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//
// 1차 점검 완료 - 9월 12일


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
