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
            Text("Pickple에 처음 오셨군요!")
                .pickpleTypography(.title01)
                .foregroundStyle(Color.neutral100)
            
            VStack(alignment: .leading, spacing: 40) {
                Text("아래의 약관에 동의하시면\n서비스를 이용하실 수 있어요")
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.neutral60)
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 8) {
                        Toggle(isOn: allOn) {}
                            .padding(.leading, 11)
                        Text("전체 동의")
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
                        HStack(spacing: 8) {
                            Toggle(isOn: $personalDataOn){}
                            
                            Text("[필수] 개인정보 수집 및 이용 동의")
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Text("보기")
                                    .underline()
                                    .foregroundStyle(Color.neutral40)
                                    
                            }
                        }
                        .toggleStyle(PickpleToggle())
                        
                        HStack(spacing: 8) {
                            Toggle(isOn: $serviceTermsOn){}
                            
                            Text("[필수] PickPle 서비스 이용약관 동의")
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Text("보기")
                                    .underline()
                                    .foregroundStyle(Color.neutral40)
                            }
                        }
                        .toggleStyle(PickpleToggle())
                        
                        HStack(spacing: 8) {
                            Toggle(isOn: $pushNotificationOn){}
                            
                            Text("[선택] 앱 내 광고 및 정보성 수신 동의")
                            
                            Spacer()
                        }
                        .toggleStyle(PickpleToggle())
                    }
                    .pickpleTypography(.body02)
                    .foregroundStyle(Color.neutral80)
                }
            }
            
            Spacer()
            
            Button(action: { onCompleted() }) {
                Text("시작하기")
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
    TermsAgreementView()
}
