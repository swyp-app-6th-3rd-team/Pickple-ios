//
//  ProfileImageView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//

import SwiftUI

struct ProfileImageView: View {
    let profileViewModel: ProfileSetupViewModel

    var body: some View {
        VStack(spacing: 40) {
            PickpleProfile(selectedImage: profileViewModel.selectedImage, type: .onCamera) { image in
                profileViewModel.setSelectedImage(image)
            }
        }
    }
}

#Preview {
    ProfileImageView(profileViewModel: ProfileSetupViewModel())
}
