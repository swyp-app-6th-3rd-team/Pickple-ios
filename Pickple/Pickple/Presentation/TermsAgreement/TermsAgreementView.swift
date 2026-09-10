//
//  TermsAgreementView.swift
//  Pickple
//
//  Created by 박윤수 on 9/6/26.
//
//MARK: - 완료

import SwiftUI

struct TermsAgreementView: View {
    @State var personalDataOn: Bool = false
    @State var serviceTermsOn: Bool = false
    @State var pushNotificationOn: Bool = false

    let profileViewModel: ProfileSetupViewModel

    private var isRequiredAgreed: Bool {
        personalDataOn && serviceTermsOn
    }

    var onCompleted: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            TermsAgreementTitle()

            VStack(alignment: .leading, spacing: 20) {
                TermsToggleAllSection(
                    personalDataOn: $personalDataOn,
                    serviceTermsOn: $serviceTermsOn,
                    pushNotificationOn: $pushNotificationOn
                )

                TermsToggleSection(
                    personalDataOn: $personalDataOn,
                    serviceTermsOn: $serviceTermsOn,
                    pushNotificationOn: $pushNotificationOn
                )
            }

            Spacer()

            Button(action: {
                Task {
                    if await profileViewModel.submitProfile() {
                        onCompleted()
                    }
                }
            }) {
                Text(TermsAgreementStrings.startButton)
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.pickple(isRequiredAgreed ? .enabled : .disabled, 56))
            .disabled(!isRequiredAgreed)
        }
        .padding(.horizontal, 20)
        .padding(.top, 45)
    }
}

#Preview {
    TermsAgreementView(profileViewModel: ProfileSetupViewModel())
}
