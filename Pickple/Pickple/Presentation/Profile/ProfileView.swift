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
                
                Spacer()
            }
            
            if let image = profileViewModel.selectedImage {
                PhotosPicker(selection: $selectedItem) {
                    image
                        .resizable()
                        .frame(width: 160, height: 160)
                        .clipShape(Circle())
                }
            } else {
                PhotosPicker(selection: $selectedItem) {
                    Circle()
                        .frame(width: 160, height: 160)
                        .foregroundStyle(Color.gray)
                    
                }
            }
            
            ZStack(alignment: .leading) {
                if nickname.isEmpty {
                    Text(ProfileStrings.nicknameText)
                        .font(.custom("Nunito-ExtraBold", size: 16)) //실제 폰트로 변경
                        .tracking(-0.02)
                        .lineSpacing(1.5)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.termsNoticeText)
                        .padding(.leading, 12)
                }
                TextField("", text: $nickname)
                    .frame(width: 353, height: 56)
                    .padding(.leading, 12)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.guestBorder, lineWidth: 1)
            }
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
