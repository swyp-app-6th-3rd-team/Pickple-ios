//
//  ProfileImageView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//

import SwiftUI
import PhotosUI

struct ProfileImageView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @State var selectedItem: PhotosPickerItem?
    
    var body: some View {
        VStack(spacing: 40) {
            PickpleProfile(selectedItem: $selectedItem, selectedImage: profileViewModel.selectedImage, type: .offCamera)
        }
        .onChange(of: selectedItem) {
            guard let selectedItem else { return }
            profileViewModel.imageSelection = selectedItem
            profileViewModel.loadTransferable(from: selectedItem)
        }
    }
}

#Preview {
    ProfileImageView(profileViewModel: ProfileViewModel())
}
