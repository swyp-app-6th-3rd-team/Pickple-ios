//
//  ProfileImageView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//
// 1차 점검 완료 - 9월 12일


import SwiftUI

struct ProfileImageView: View {
    let profileViewModel: ProfileSetupViewModel
    var size: CGFloat = 160

    var body: some View {
        VStack(spacing: 40) {
            PickpleProfile(
                selectedImage: profileViewModel.selectedImage,
                type: .onCamera,
                onSelect: { image in profileViewModel.setSelectedImage(image) },
                existingImageUrl: profileViewModel.existingImageUrl,
                size: size
            )
        }
    }
}

#Preview {
    ProfileImageView(profileViewModel: ProfileSetupViewModel())
}
