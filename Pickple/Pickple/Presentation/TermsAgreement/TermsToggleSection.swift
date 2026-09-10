//
//  TermsToggleSection.swift
//  Pickple
//
//  Created by 박윤수 on 9/9/26.
//

import SwiftUI

struct TermsToggleSection: View {
    @Binding var personalDataOn: Bool
    @Binding var serviceTermsOn: Bool
    @Binding var pushNotificationOn: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            TermsToggleRow(isOn: $personalDataOn, title: TermsAgreementStrings.personalDataTitle, url: TermsAgreementStrings.privacy)
            TermsToggleRow(isOn: $serviceTermsOn, title: TermsAgreementStrings.serviceTermsTitle, url: TermsAgreementStrings.ToU)
            TermsToggleRow(isOn: $pushNotificationOn, title: TermsAgreementStrings.pushNotificationTitle, showsViewButton: false)
        }
        .pickpleTypography(.body02)
        .foregroundStyle(Color.neutral80)
    }
}

#Preview {
    TermsToggleSection(
        personalDataOn: .constant(false),
        serviceTermsOn: .constant(false),
        pushNotificationOn: .constant(false)
    )
}
