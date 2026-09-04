//
//  ProfileTitleView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//

import SwiftUI

struct ProfileTitleView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(ProfileSetupStrings.profileTitle)
                    .pickpleTypography(.heading02)
                    .foregroundStyle(Color.black)
                
                Text(ProfileSetupStrings.profileGuideText)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.neutral60)
            }
        }
    }
}

#Preview {
    ProfileTitleView()
}
