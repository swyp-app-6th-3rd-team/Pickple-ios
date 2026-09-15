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
    // 수정 화면 진입 시 loadCurrentProfile()로 불러온 원래 닉네임. save()에서 중복 확인을
    // 건너뛸지 판단하는 기준으로만 쓴다(신규 등록 플로우에서는 nil로 남아 항상 검사한다).
    private var originalNickname: String?

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

    // 등록/수정 둘 다 "닉네임 유효성 확인 → 중복 검사 → (새 사진 있으면 업로드) → 실제 저장 호출"
    // 순서가 같고 마지막 저장 호출(register/update)만 달라서 공용으로 뺐다.
    @MainActor
    func submitProfile() async -> Bool {
        await save { imageUrl in
            try await self.profileRepository.registerProfile(nickname: self.nickname, profileImageUrl: imageUrl)
        }
    }

    @MainActor
    func updateProfile() async -> Bool {
        await save { imageUrl in
            try await self.profileRepository.updateProfile(nickname: self.nickname, profileImageUrl: imageUrl)
        }
    }

    @MainActor
    private func save(_ persist: (String?) async throws -> Void) async -> Bool {
        guard isNicknameValid() else { return false }
        isSubmitting = true
        defer { isSubmitting = false }
        do {
            // 닉네임을 안 바꿨으면 중복 확인을 건너뛴다 — GET /users/nickname/availability는 익명 조회라
            // 서버가 "지금 이 닉네임의 주인이 나"라는 걸 몰라서, 안 바뀐 본인 닉네임도 "이미 사용 중"으로
            // 판정해버린다. 그러면 사진만 바꾸는 수정조차 매번 중복 에러로 실패하던 문제가 있었다.
            if nickname != originalNickname {
                let availability = try await profileRepository.checkNicknameAvailability(nickname)
                guard availability.isAvailable else {
                    errorMessage = availability.message
                    return false
                }
            }
            // 새로 고른 사진이 없으면 nil을 보낸다 — 서버가 기존 사진을 그대로 유지한다(API_SPEC 기준).
            var uploadedImageUrl: String?
            if let selectedUIImage {
                uploadedImageUrl = try await profileRepository.uploadProfileImage(selectedUIImage)
            }
            try await persist(uploadedImageUrl)
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
            originalNickname = profile.nickname
            existingImageUrl = profile.profileImageUrl.flatMap(URL.init(string:))
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
