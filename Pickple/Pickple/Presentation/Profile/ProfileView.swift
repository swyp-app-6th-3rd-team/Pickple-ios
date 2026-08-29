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

    var body: some View {
        VStack(spacing: 32) {
            //XMARK: - ProfileView Title
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(ProfileStrings.profileTitle)
                        .pickpleTypography(.body01Bold)
                        .foregroundStyle(Color.black)
                    
                    Text(ProfileStrings.profileGuideText)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.textSecondary)
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
                    trailingAccessory: .text("\(profileViewModel.nickname.count)/\(profileViewModel.nicknameMaxLength)")
                )
                .onChange(of: profileViewModel.nickname) { _, newValue in
                    profileViewModel.nickname = profileViewModel.filteredNickname(newValue)
                }
                // TODO: 백엔드와 연동해서 닉네임 중복 검사 로직 추가
            }

            Spacer()

            Button(action: { }) {
                Text("확인")
            }
            .buttonStyle(.pickple(profileViewModel.isNicknameValid ? .enabled : .disabled))
            .disabled(!profileViewModel.isNicknameValid)
        }
        .onChange(of: selectedItem) {
            guard let selectedItem else { return }
            profileViewModel.imageSelection = selectedItem
            profileViewModel.loadTransferable(from: selectedItem)
        }
    }

    
}



#Preview {
    ProfileView()
}
