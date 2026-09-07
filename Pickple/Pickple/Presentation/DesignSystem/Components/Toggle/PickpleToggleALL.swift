//
//  PickpleToggleView.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//

import SwiftUI

struct PickpleToggleALL: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        if configuration.isOn {
            ZStack {
                Circle()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.yellow60)
                    .overlay {
                        Circle()
                            .stroke(Color.yellow60)
                    }
                Image("PickpleCheck")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(Color.navy60)
                    
            }
            .onTapGesture {
                configuration.isOn.toggle()
            }
        } else {
            ZStack(alignment: .center) {
                Circle()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.clear)
                    .overlay {
                        Circle()
                            .stroke(Color.neutral30)
                    }
                Image("PickpleCheck")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(Color.neutral30)
            }
            .onTapGesture {
                configuration.isOn.toggle()
            }
        }
            
    }
}

#Preview {
    TermsAgreementView(profileViewModel: ProfileSetupViewModel())
}
