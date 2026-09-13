//
//  TermsToggleAllSection.swift
//  Pickple
//
//  Created by 박윤수 on 9/9/26.
//
// 1차 점검 완료 - 9월 13일

import SwiftUI

struct TermsToggleAllSection: View {
    @Binding var personalDataOn: Bool
    @Binding var serviceTermsOn: Bool
    @Binding var pushNotificationOn: Bool

    private var allOn: Binding<Bool> {
        Binding(
            get: { personalDataOn && serviceTermsOn && pushNotificationOn },
            set: { newValue in
                personalDataOn = newValue
                serviceTermsOn = newValue
                pushNotificationOn = newValue
            }
        )
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Toggle(isOn: allOn) {}
                .padding(.leading, 11)
            Text(TermsAgreementStrings.agreeAll)
                .pickpleTypography(.body01)
                .foregroundStyle(Color.navy60)

            Spacer()
        }
        .toggleStyle(PickpleToggleALL())
        .frame(maxWidth: .infinity, minHeight: 56)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.neutral5)
        )
    }
}

#Preview {
    TermsToggleAllSection(
        personalDataOn: .constant(false),
        serviceTermsOn: .constant(false),
        pushNotificationOn: .constant(false)
    )
}
