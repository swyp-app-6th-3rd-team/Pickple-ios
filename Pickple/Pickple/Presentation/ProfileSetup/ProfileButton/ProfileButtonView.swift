//
//  ProfileButtonView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//
// 1차 점검 완료 - 9월 12일


import SwiftUI

struct ProfileButtonView: View {
    let profileViewModel: ProfileSetupViewModel
    var onCompleted: () -> Void = {}

    var body: some View {
        Button(action: { onCompleted() }) {
            Text(ProfileSetupStrings.confirmButton)
        }
        .frame(maxWidth: .infinity) //반응형
        .buttonStyle(.pickple(isEnabled ? .enabled : .disabled, 56))
        .disabled(!isEnabled)
    }

    private var isEnabled: Bool {
        profileViewModel.isNicknameAvailable && !profileViewModel.isSubmitting
    }
}

#Preview {
    ProfileButtonView(profileViewModel: ProfileSetupViewModel())
}
