//
//  ProfileSetupView.swift
//  Pickple
//
//  Created by 박윤수 on 8/26/26.
//
// 1차 점검 완료 - 9월 12일


import SwiftUI
import PhotosUI

struct ProfileSetupView: View {
    @State var profileViewModel: ProfileSetupViewModel = ProfileSetupViewModel()
    var onCompleted: () -> Void = {}

    @State private var showsTermsAgreement = false
    
    var body: some View {
        VStack(spacing: 40) {
            HStack {
                profileSetupTitle
                    .padding(.horizontal, 20)
                    .padding(.top, 56)
                
                Spacer()
            }
            
            //XMARK: - Profile Image
            PickpleProfile(
                selectedImage: profileViewModel.selectedImage,
                type: .onCamera,
                onSelect: { image in profileViewModel.setSelectedImage(image) },
                existingImageUrl: profileViewModel.existingImageUrl
            )
            
            //MARK: - TextField
            ProfileTextFieldView(profileViewModel: profileViewModel)
                .padding(.horizontal, 20)
            
            Spacer()
            
            //XMARK: - Button
            ProfileButtonView(profileViewModel: profileViewModel, onCompleted: {
                showsTermsAgreement = true
            })
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .alert(ProfileSetupStrings.registerFailedTitle, isPresented: Binding(
            get: { profileViewModel.errorMessage != nil },
            set: { isPresented in if !isPresented { profileViewModel.errorMessage = nil } }
        )) {
            Button(ProfileSetupStrings.confirmButton, role: .cancel) {}
        } message: {
            Text(profileViewModel.errorMessage ?? "")
        }
        .background(Color.white.ignoresSafeArea())
        .sheet(isPresented: $showsTermsAgreement)  {
            TermsAgreementView(profileViewModel: profileViewModel, onCompleted: {
                showsTermsAgreement = false
                onCompleted()
            })
            
                .interactiveDismissDisabled()
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(482)])
        }
    }
    
    // MARK: - ProfileSetupTitle
    private var profileSetupTitle: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(ProfileSetupStrings.profileTitle)
                    .pickpleTypography(.heading02)
                    .foregroundStyle(Color.black)
                
                Text(ProfileSetupStrings.profileGuideText)
                    .pickpleTypography(.body01_500)
                    .foregroundStyle(Color.neutral60)
            }
        }
    }
}


#Preview {
    ProfileSetupView()
}

