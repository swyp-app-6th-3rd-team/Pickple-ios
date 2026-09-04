//
//  SwiftUIView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//

import SwiftUI

struct ProfileTextFieldView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    @FocusState private var isFocused: Bool
    
    private var state: PickpleTextFieldStateType {
        profileViewModel.textFieldState(isFocused)
    }
    
    var body: some View {
        VStack {
            PickpleTextField(
                text: $profileViewModel.nickname,
                type: .both,
                placeholder: ProfileStrings.nicknameText,
                trailingAccessory: .text("\(profileViewModel.nickname.count)/\(profileViewModel.nicknameMaxLength)"),
                caption: profileViewModel.nicknameCaption(state),
                state: state
            )
        }
        .frame(maxWidth: .infinity) //반응형
        .focused($isFocused)
        .onChange(of: profileViewModel.nickname) { _, newValue in
            profileViewModel.nickname = profileViewModel.filteredNickname(newValue)
            
        }
    }
}

#Preview {
    ProfileTextFieldView(profileViewModel: ProfileViewModel())
}
