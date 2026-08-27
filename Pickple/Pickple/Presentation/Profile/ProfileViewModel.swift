//
//  ProfileViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 8/26/26.
//
import SwiftUI
import PhotosUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var imageSelection: PhotosPickerItem?
    @Published var selectedImage: Image?

    @discardableResult
    func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: Image.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else { return }
                switch result {
                case .success(let image?):
                    self.selectedImage = image
                case .success(nil):
                    self.selectedImage = nil
                case .failure(let error):
                    print("error")
                }
            }
        }
    }
}
