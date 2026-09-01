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
    
    var body: some View {
        VStack(spacing: 40) {
            //Spacer()
            HStack {
                //XMARK: - Title
                ProfileTitleView()
                    .frame(width: 225) //Fixed
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
            ProfileButtonView(profileViewModel: profileViewModel)
                .frame(width: 353, height: 56) //fixed
        }

    }
}




#Preview {
    ProfileView()
}

