//
//  TermsAgreementView.swift
//  Pickple
//
//  Created by 박윤수 on 9/6/26.
//
//MARK: - 완료
// 1차 점검 완료 - 9월 13일
// 1차 리팩토링 완료 - 10월 2일

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
                
                termsToggleSection
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
    
    //MARK: - TermsToggleSection
    private var termsToggleSection: some View {
        VStack(spacing: 16) {
            TermsToggleRow(isOn: $personalDataOn, title: TermsAgreementStrings.personalDataTitle, url: TermsAgreementStrings.privacy)
            TermsToggleRow(isOn: $serviceTermsOn, title: TermsAgreementStrings.serviceTermsTitle, url: TermsAgreementStrings.ToU)
            TermsToggleRow(isOn: $pushNotificationOn, title: TermsAgreementStrings.pushNotificationTitle, showsViewButton: false)
        }
    }
}



#Preview {
    TermsAgreementView(profileViewModel: ProfileSetupViewModel())
}
