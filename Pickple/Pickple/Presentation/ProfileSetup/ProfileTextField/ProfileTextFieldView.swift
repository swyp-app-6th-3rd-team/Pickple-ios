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

    private var state: PickpleTextFieldStateType {
        profileViewModel.textFieldState(isFocused)
    }

    var body: some View {
        VStack {
            PickpleTextField(
                text: $profileViewModel.nickname,
                type: .both,
                placeholder: ProfileSetupStrings.nicknameText,
                trailingAccessory: .text("\(profileViewModel.nickname.count)/\(profileViewModel.nicknameMaxLength)"),
                caption: profileViewModel.nicknameCaption(state),
                state: state
            )
        }
        .frame(maxWidth: .infinity) //반응형
        .focused($isFocused)
        // TextField를 $profileViewModel.nickname에 직접 바인딩해야 한다 — 커스텀
        // Binding(get:set:)으로 감싸면 특수문자를 걸러내도 TextField(UIKit 내부 버퍼)가
        // 강제로 재동기화되지 않아 화면에 방금 입력한 특수문자가 그대로 남는 문제가 있었다.
        // 필터링 왕복(원본→필터링값)으로 onChange가 두 번 불려도, "이미 확인해본 값
        // 그대로면 복원만 하고 서버는 다시 안 부르는" 처리는 nicknameDidChange() 안에서
        // 한다 — 여기서는 그냥 매번 부르면 된다.
        .onChange(of: profileViewModel.nickname) { _, newValue in
            let filtered = profileViewModel.filteredNickname(newValue)
            if filtered != newValue {
                profileViewModel.nickname = filtered
                return   // 필터링으로 값이 다시 바뀌면 이 onChange가 한 번 더 불려서 그때 확인한다.
            }
            profileViewModel.nicknameDidChange()
        }
    }
}

#Preview {
    ProfileTextFieldView(profileViewModel: ProfileSetupViewModel())
}
