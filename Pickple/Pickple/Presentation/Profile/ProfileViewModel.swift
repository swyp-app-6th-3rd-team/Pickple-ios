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
    @Published var nickname: String = ""

    let nicknameMaxLength = 5

    //Progerss라는 진행상황 반환값을 일단 안쓰기에 표기
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

    func isNicknameValid() -> Bool {
        if nickname.isEmpty { return false }
        else { return true }
        // TODO: 백엔드와 연동해서 닉네임 중복 검사 로직 추가

    }
    
    func textFieldState(_ isFocused: Bool, _ nickname: String) -> PickpleTextFieldStateType{
        if isFocused && nickname.isEmpty { return .select}
        else if isFocused && isNicknameValid() { return .success}
        else if isFocused && !isNicknameValid() { return .error}
        else { return ._default}
    }
    

}
