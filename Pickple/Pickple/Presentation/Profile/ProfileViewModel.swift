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
    @Published var isSubmitting = false
    @Published var errorMessage: String?

    let nicknameMaxLength = 5
    private let profileRepository: ProfileRepository

    init(profileRepository: ProfileRepository = MockProfileRepository()) {
        self.profileRepository = profileRepository
    }

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

    // 형식(비어있는지)만 로컬로 확인한다. 중복 여부는 비동기 서버 확인이 필요해서
    // submitProfile()에서 checkNicknameAvailability(_:)로 따로 처리한다.
    func isNicknameValid() -> Bool {
        !nickname.isEmpty
    }
    
    func textFieldState(_ isFocused: Bool) -> PickpleTextFieldStateType{
        if isFocused && self.nickname.isEmpty { return .select}
        else if isFocused && isNicknameValid() { return .success}
        else if isFocused && !isNicknameValid() { return .error}
        else { return ._default}
    }
    
    func nicknameCaption(_ state: PickpleTextFieldStateType) -> String {
        switch state {
        case .error: return ProfileStrings.error
        case .success: return ProfileStrings.success
        default: return ""
        }
    }

    @MainActor
    func submitProfile() async -> Bool {
        guard isNicknameValid() else { return false }
        isSubmitting = true
        defer { isSubmitting = false }
        do {
            let availability = try await profileRepository.checkNicknameAvailability(nickname)
            guard availability.isAvailable else {
                errorMessage = availability.message
                return false
            }
            try await profileRepository.registerProfile(nickname: nickname)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
