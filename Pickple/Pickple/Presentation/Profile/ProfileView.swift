//
//  ProfileView.swift
//  Pickple
//
//  Created by 박윤수 on 8/26/26.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject var profileViewModel: ProfileViewModel = ProfileViewModel()
    
    @State var selectedItem: PhotosPickerItem?
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 32) {
            //XMARK: - ProfileView Title
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(ProfileStrings.profileTitle)
                        .pickpleTypography(.title02)
                        .foregroundStyle(Color.black)
                    
                    Text(ProfileStrings.profileGuideText)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.neutral60)
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                
                Spacer()
            }
            
            VStack(spacing: 40) {
                PickpleProfile(selectedItem: $selectedItem, selectedImage: profileViewModel.selectedImage, type: .offCamera)
                
                PickpleTextField(
                    text: $profileViewModel.nickname,
                    type: .both,
                    placeholder: ProfileStrings.nicknameText,
                    trailingAccessory: .text("\(profileViewModel.nickname.count)/\(profileViewModel.nicknameMaxLength)"),
                    state: profileViewModel.textFieldState(isFocused)
                )
            }
            
            .focused($isFocused)
            .onChange(of: profileViewModel.nickname) { _, newValue in
                profileViewModel.nickname = profileViewModel.filteredNickname(newValue)
                
            }
            .padding(.horizontal, 20)
            
            .onChange(of: selectedItem) {
                guard let selectedItem else { return }
                profileViewModel.imageSelection = selectedItem
                profileViewModel.loadTransferable(from: selectedItem)
            }
            
            Spacer()
            
            Button(action: { }) {
                Text("확인")
            }
            .padding(.horizontal, 20)
            .buttonStyle(.pickple(profileViewModel.isNicknameValid() ? .enabled : .disabled))
            .disabled(!profileViewModel.isNicknameValid())
        }
    }
    
}

#Preview {
    ProfileView()
}

