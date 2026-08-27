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

    let nicknameMaxLength = 5

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
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func filteredNickname(_ input: String) -> String {
        let filtered = input.filter { $0.isLetter || $0.isNumber }
        return String(filtered.prefix(nicknameMaxLength))
    }

    func isValidNickname(_ nickname: String) -> Bool {
        if nickname.isEmpty { return false }
        else { return true }
        //닉네임 중복 체크 로직 추가 예정
    }
}
