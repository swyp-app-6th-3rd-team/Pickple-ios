//
//  ProfileSetupView.swift
//  Pickple
//
//  Created by 박윤수 on 8/26/26.
//

import SwiftUI
import PhotosUI

struct ProfileSetupView: View {
    @State var profileViewModel: ProfileSetupViewModel = ProfileSetupViewModel()
    var onCompleted: () -> Void = {}
    
    @Environment(\.isLoggedIn) private var isLoggedIn
    @State private var showsTermsAgreement = false
    
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
            ProfileButtonView(profileViewModel: profileViewModel, onCompleted: { if isLoggedIn {
                onCompleted()
            } else {
                showsTermsAgreement = true
            }
            })
            .padding(.horizontal, 20)
        }
        .alert(ProfileSetupStrings.registerFailedTitle, isPresented: Binding(
            get: { profileViewModel.errorMessage != nil },
            set: { isPresented in if !isPresented { profileViewModel.errorMessage = nil } }
        )) {
            Button(ProfileSetupStrings.confirmButton, role: .cancel) {}
        } message: {
            Text(profileViewModel.errorMessage ?? "")
        }
        .sheet(isPresented: $showsTermsAgreement)  {
            TermsAgreementView(onCompleted: {
                showsTermsAgreement = false
                onCompleted()
            })
                .interactiveDismissDisabled()
        }
    }
}




#Preview {
    ProfileSetupView()
}

