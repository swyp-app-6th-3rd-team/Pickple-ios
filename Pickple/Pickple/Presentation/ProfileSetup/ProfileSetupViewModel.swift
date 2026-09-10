//
//  ProfileSetupViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 8/26/26.
//
import SwiftUI
import UIKit

@Observable
class ProfileSetupViewModel {
    var selectedImage: Image?
    // 실제 업로드(POST /images)를 붙일 때 raw 이미지가 필요해서 표시용 Image와 별도로 들고 있는다.
    var selectedUIImage: UIImage?
    // 수정 화면 진입 시 서버에 저장된 기존 프로필 사진. 새 사진을 고르기 전까지 이걸 보여준다.
    var existingImageUrl: URL?
    var nickname: String = ""
    var isSubmitting = false
    var errorMessage: String?

    let nicknameMaxLength = 5
    private let profileRepository: ProfileRepository

    init(profileRepository: ProfileRepository = MockProfileRepository()) {
        self.profileRepository = profileRepository
    }

    func setSelectedImage(_ image: UIImage) {
        selectedUIImage = image
        selectedImage = Image(uiImage: image)
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
        case .error: return ProfileSetupStrings.error
        case .success: return ProfileSetupStrings.success
        default: return ""
        }
    }

    // 등록/수정 둘 다 "닉네임 유효성 확인 → 중복 검사 → 실제 저장 호출" 순서가 같고
    // 마지막 저장 호출(register/update)만 달라서 공용으로 뺐다.
    @MainActor
    func submitProfile() async -> Bool {
        await save { try await self.profileRepository.registerProfile(nickname: self.nickname) }
    }

    @MainActor
    func updateProfile() async -> Bool {
        await save { try await self.profileRepository.updateProfile(nickname: self.nickname) }
    }

    @MainActor
    private func save(_ persist: () async throws -> Void) async -> Bool {
        guard isNicknameValid() else { return false }
        isSubmitting = true
        defer { isSubmitting = false }
        do {
            let availability = try await profileRepository.checkNicknameAvailability(nickname)
            guard availability.isAvailable else {
                errorMessage = availability.message
                return false
            }
            try await persist()
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    @MainActor
    func loadCurrentProfile() async {
        do {
            let profile = try await profileRepository.fetchMyProfile()
            nickname = profile.nickname ?? ""
            existingImageUrl = profile.profileImageUrl.flatMap(URL.init(string:))
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
