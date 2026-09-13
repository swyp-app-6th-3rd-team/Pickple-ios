//
//  TermsToggleRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  TermsAgreementView의 약관 항목 3개(필수 2 + 선택 1)가 거의 동일한 형태라 공용화했다.
//  "보기" 버튼은 필수 약관 2개에만 있고 선택 항목엔 없어서 showsViewButton으로 껐다 켰다 한다.
// 1차 점검 완료 - 9월 13일

import SwiftUI

struct TermsToggleRow: View {
    @Binding var isOn: Bool
    let title: String
    var showsViewButton: Bool = true
    var url: String = ""
    var onViewTapped: () -> Void = {}

    var body: some View {
        HStack(spacing: 8) {
            Toggle(isOn: $isOn) {}

            Text(title)
                .pickpleTypography(.body02)
                .foregroundStyle(Color.neutral80)
                
            Spacer()

            if showsViewButton {
                Link(destination: URL(string: url)!) {
                    Text(TermsAgreementStrings.viewButton)
                        .pickpleTypography(.body02)
                        .underline()
                        .foregroundStyle(Color.neutral40)
                }
            }
        }
        .toggleStyle(PickpleToggle())
    }
}

#Preview {
    @Previewable @State var isOn = false
    VStack(spacing: 16) {
        TermsToggleRow(isOn: $isOn, title: TermsAgreementStrings.personalDataTitle, url: "")
        TermsToggleRow(isOn: $isOn, title: TermsAgreementStrings.pushNotificationTitle, showsViewButton: false)
    }
    .pickpleTypography(.body02)
    .foregroundStyle(Color.neutral80)
    .padding()
}
