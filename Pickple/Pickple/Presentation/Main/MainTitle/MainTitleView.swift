//
//  MainTitleView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//

import SwiftUI

struct MainTitleView: View {
    var body: some View {
        ZStack {
            PickpleGNB(
                leading: .image(Image("PickpleTitle")),
                center: .none,
                trailing: .button(icon: Image("PickpleAlertOff"), action: {})
            )

            Image("PickpleTolltip")
                .padding(.trailing, 2)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MainView()
}
