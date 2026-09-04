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
    var onCompleted: () -> Void = {}

    var body: some View {
        VStack(spacing: 40) {
            //Spacer()
            HStack {
                //XMARK: - Title
                ProfileTitleView()
                    .padding(.horizontal, 20)
                    .padding(.top, 56)

                Spacer()
            }

            //XMARK: - Profile Image
            ProfileImageView(profileViewModel: profileViewModel)

            //MARK: - TextField
            ProfileTextFieldView(profileViewModel: profileViewModel)
                .padding(.horizontal, 20)
            
            Spacer()

            //XMARK: - Button
            ProfileButtonView(profileViewModel: profileViewModel, onCompleted: onCompleted)
                .padding(.horizontal, 20)
        }
        .alert(ProfileStrings.registerFailedTitle, isPresented: Binding(
            get: { profileViewModel.errorMessage != nil },
            set: { isPresented in if !isPresented { profileViewModel.errorMessage = nil } }
        )) {
            Button(ProfileStrings.confirmButton, role: .cancel) {}
        } message: {
            Text(profileViewModel.errorMessage ?? "")
        }
    }
}




#Preview {
    ProfileView()
}

