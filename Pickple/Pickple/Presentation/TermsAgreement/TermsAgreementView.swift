//
//  TermsAgreementView.swift
//  Pickple
//
//  Created by 박윤수 on 9/6/26.
//
//  TODO: 실제 UI(전체동의 토글, 서비스 이용약관/개인정보 수집 동의 항목, 각 항목 클릭 시 노션 링크 연결) 채울 것.
//  지금은 신규 가입자가 이 화면을 거쳐 온다는 것만 확인 가능한 빈 상태.

import SwiftUI

struct TermsAgreementView: View {
    @State var personalDataOn: Bool = false
    @State var serviceTermsOn: Bool = false
    @State var pushNotificationOn: Bool = false
    
    let profileViewModel: ProfileSetupViewModel
    
    private var isRequiredAgreed: Bool {
        personalDataOn && serviceTermsOn
    }
    
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
    
    var onCompleted: () -> Void = {}
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(TermsAgreementStrings.welcomeTitle)
                .pickpleTypography(.title01)
                .foregroundStyle(Color.neutral100)

            VStack(alignment: .leading, spacing: 40) {
                Text(TermsAgreementStrings.welcomeDescription)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.neutral60)

                VStack(alignment: .leading, spacing: 20) {
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


                    VStack(spacing: 16) {
                        TermsToggleRow(isOn: $personalDataOn, title: TermsAgreementStrings.personalDataTitle)
                        TermsToggleRow(isOn: $serviceTermsOn, title: TermsAgreementStrings.serviceTermsTitle)
                        TermsToggleRow(isOn: $pushNotificationOn, title: TermsAgreementStrings.pushNotificationTitle, showsViewButton: false)
                    }
                    .pickpleTypography(.body02)
                    .foregroundStyle(Color.neutral80)
                }
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
