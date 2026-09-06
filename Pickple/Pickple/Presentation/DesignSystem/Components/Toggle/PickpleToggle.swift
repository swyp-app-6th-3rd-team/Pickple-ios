//
//  PickpleToggleView.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//

import SwiftUI

struct PickpleToggle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        if configuration.isOn {
            Image("PickpleCheck")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundStyle(Color.yellow60)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        } else {
            Image("PickpleCheck")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundStyle(Color.neutral30)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
        
    }
}

#Preview {
    TermsAgreementView()
}
