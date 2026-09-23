//
//  TermsAgreementView.swift
//  Pickple
//
//  Created by 박윤수 on 9/6/26.
//
//MARK: - 완료
// 1차 점검 완료 - 9월 13일

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
            TermsAgreementTitle
            
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
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 46)
        .background(Color.white)
    }
    
    //MARK: - TermsAgreementTitle
    private var TermsAgreementTitle: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(TermsAgreementStrings.welcomeTitle)
                    .pickpleTypography(.title01)
                    .foregroundStyle(Color.black)
                
                Text(TermsAgreementStrings.welcomeDescription)
                    .pickpleTypography(.body01_500)
                    .foregroundStyle(Color.neutral60)
            }
            Spacer()
        }
    }
}



#Preview {
    TermsAgreementView(profileViewModel: ProfileSetupViewModel())
}
