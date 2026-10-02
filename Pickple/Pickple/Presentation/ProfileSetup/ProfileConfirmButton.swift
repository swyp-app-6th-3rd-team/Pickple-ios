//
//  ProfileConfirmButton.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//
// 1차 점검 완료 - 9월 12일
// 1차 리팩토링 완료 - 10월 2일


import SwiftUI

struct ProfileConfirmButton: View {
    let profileViewModel: ProfileSetupViewModel
    var onCompleted: () -> Void = {}

    var body: some View {
        Button(action: onCompleted) {
            Text(ProfileSetupStrings.confirmButton)
        }
        .buttonStyle(.pickple(isEnabled ? .enabled : .disabled, 56))
        .disabled(!isEnabled)
    }

    private var isEnabled: Bool {
        profileViewModel.isNicknameAvailable == true && !profileViewModel.isSubmitting
    }
}

#Preview {
    ProfileConfirmButton(profileViewModel: ProfileSetupViewModel())
}
