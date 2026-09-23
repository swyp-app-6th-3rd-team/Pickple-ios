//
//  SwiftUIView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//
// 1차 점검 완료 - 9월 12일


import SwiftUI

struct ProfileTextFieldView: View {
    @Bindable var profileViewModel: ProfileSetupViewModel

    @FocusState private var isFocused: Bool

    // isNicknameAvailable이 true인데 nicknameCheckMessage가 비어있으면, 서버 확인 없이
    // "원래 쓰던 닉네임 그대로"라 건너뛴 경우다(ProfileSetupViewModel.nicknameDidChange()의
    // originalNickname 분기) — 이때는 성공으로 확정 표시하지 않고 그냥 포커스 기준으로만
    // 보여준다. 실제로 서버 확인을 거친 성공/실패는 항상 메시지가 채워져 있다.
    private var state: PickpleTextFieldStateType {
        if let isAvailable = profileViewModel.isNicknameAvailable, !profileViewModel.nicknameCheckMessage.isEmpty {
            return isAvailable ? .success : .error
        }
        return isFocused ? .ing : ._default
    }

    var body: some View {
        PickpleTextField(
            text: $profileViewModel.nickname,
            placeholder: ProfileSetupStrings.nicknameText,
            trailingAccessory: .text("\(profileViewModel.nickname.count)/\(profileViewModel.nicknameMaxLength)"),
            title: ProfileSetupStrings.nickname,
            caption: profileViewModel.nicknameCheckMessage,
            state: state
        )
        .focused($isFocused)
        .onChange(of: profileViewModel.nickname) { _, newValue in
            let filtered = profileViewModel.filteredNickname(newValue)
            if filtered != newValue {
                profileViewModel.nickname = filtered
                return
            }
            profileViewModel.nicknameDidChange()
        }
    }
}

#Preview {
    ProfileTextFieldView(profileViewModel: ProfileSetupViewModel())
}
