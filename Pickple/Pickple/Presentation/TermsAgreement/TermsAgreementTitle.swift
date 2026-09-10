//
//  TermsAgreementTitle.swift
//  Pickple
//
//  Created by 박윤수 on 9/9/26.
//

import SwiftUI

struct TermsAgreementTitle: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(TermsAgreementStrings.welcomeTitle)
                    .pickpleTypography(.title01)
                    .foregroundStyle(Color.black)

                    Text(TermsAgreementStrings.welcomeDescription)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.neutral60)
            }
            Spacer()
        }
    }
}

#Preview {
    TermsAgreementTitle()
}
