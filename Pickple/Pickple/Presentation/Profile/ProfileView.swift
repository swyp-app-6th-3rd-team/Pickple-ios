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
    @State private var nickname: String = ""

    var body: some View {
        VStack(spacing: 32) {
            //XMARK: - ProfileView Title
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(ProfileStrings.profileTitle)
                        .font(.custom("Nunito-ExtraBold", size: 14))
                        .tracking(-0.02)
                        .lineSpacing(1.45)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.textPrimary)
                    
                    Text(ProfileStrings.profileGuideText)
                        .font(.custom("Nunito-ExtraBold", size: 14))
                        .tracking(-0.02)
                        .lineSpacing(1.45)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.textSecondary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                
                Spacer()
            }
            
            VStack(spacing: 40) {
                PickpleProfile(selectedItem: $selectedItem, selectedImage: profileViewModel.selectedImage, type: .offCamera)
                
                PickpleTextField(
                    text: $nickname,
                    type: .both,
                    placeholder: ProfileStrings.nicknameText,
                    trailingAccessory: .text("\(nickname.count)/\(profileViewModel.nicknameMaxLength)")
                )
            }
            .onChange(of: nickname) { _, newValue in
                nickname = profileViewModel.filteredNickname(newValue)
                // 백엔드와 연동해서 닉네임 중복 검사 로직 추가
            }
            
            Spacer()
            
            Button(action: { }) {
                Text("확인")
            }
            .buttonStyle(.pickple(profileViewModel.isValidNickname(nickname) ? .enabled : .disabled))
            .disabled(!profileViewModel.isValidNickname(nickname))
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
