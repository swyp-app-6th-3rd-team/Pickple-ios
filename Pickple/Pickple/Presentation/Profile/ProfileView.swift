//
//  ProfileView.swift
//  Pickple
//
//  Created by 박윤수 on 8/26/26.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject var proFileViewModel: ProfileViewModel = ProfileViewModel()
    
    @State var selectedItem: PhotosPickerItem?
    
    @FocusState private var isFocused: Bool
    
    private var state: PickpleTextFieldStateType {
        proFileViewModel.textFieldState(isFocused)
    }
    
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
                PickpleProfile(selectedItem: $selectedItem, selectedImage: proFileViewModel.selectedImage, type: .offCamera)
                
                PickpleTextField(
                    text: $proFileViewModel.nickname,
                    type: .both,
                    placeholder: ProfileStrings.nicknameText,
                    trailingAccessory: .text("\(proFileViewModel.nickname.count)/\(proFileViewModel.nicknameMaxLength)"),
                    caption: proFileViewModel.nicknameCaption(state),
                    state: proFileViewModel.textFieldState(isFocused)
                )
            }
            
            .focused($isFocused)
            .onChange(of: proFileViewModel.nickname) { _, newValue in
                proFileViewModel.nickname = proFileViewModel.filteredNickname(newValue)
                
            }
            .padding(.horizontal, 20)
            
            .onChange(of: selectedItem) {
                guard let selectedItem else { return }
                proFileViewModel.imageSelection = selectedItem
                proFileViewModel.loadTransferable(from: selectedItem)
            }
            
            Spacer()
            
            Button(action: { }) {
                Text("확인")
            }
            .padding(.horizontal, 20)
            .buttonStyle(.pickple(proFileViewModel.isNicknameValid() ? .enabled : .disabled))
            .disabled(!proFileViewModel.isNicknameValid())
        }
    }
    
}

#Preview {
    ProfileView()
}

