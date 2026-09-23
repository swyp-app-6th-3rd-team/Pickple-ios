//
//  ProfileSetupViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 8/26/26.
//
//
// 1. 입력 중 / 기본 / 사용 가능 / 사용 불가능 상태에 따른 입력창 UI 변경
// 2. 중복 체크 및 사용 가능 기능
// 3. 닉네임 수정의 경우 기존 닉네임 대입
// 4. 글자 수 제한
// 5. 특수문자 입력(띄어쓰기 포함)X

// 변화 체크(didChange) -> 중복 체크(isNickname)

import SwiftUI
import UIKit

@Observable
class ProfileSetupViewModel {
    var selectedImage: Image?
    var selectedUIImage: UIImage?
    var existingImageUrl: URL?
    var nickname: String = ""
    var isSubmitting = false
    var errorMessage: String?
    var nicknameCheckMessage: String = ""
    var isNicknameAvailable: Bool?
    
    let nicknameMaxLength = 5
    
    private var nicknameCheckTask: Task<Void, Never>?
    private var originalNickname: String?
    private var lastCheckedNickname: String?
    private var lastCheckedAvailability: NicknameAvailability?
    
    private let nicknameCheckDebounce: Duration = .milliseconds(500)
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

    // 텍스트 입력창의 텍스트가 변했는가?
    // 수정의 경우 원래 닉네임과 같을 경우 변하지 않은 것으로 처리
    @MainActor
    func nicknameDidChange() {
        isNicknameAvailable = nil
        nicknameCheckTask?.cancel()

        guard isNicknameValid() else { return }

        // 본인이 원래 쓰던 닉네임 그대로면 중복확인을 건너뛴다
        if nickname == originalNickname {
            isNicknameAvailable = true
            return
        }

        // 마지막 닉네임과 비교 후 닉네임 사용 가능 상태 업데이트
        if nickname == lastCheckedNickname, let result = lastCheckedAvailability {
            isNicknameAvailable = result.isAvailable
            nicknameCheckMessage = result.message
            return
        }

        nicknameCheckTask = Task { [weak self] in
            guard let self else { return }
            try? await Task.sleep(for: self.nicknameCheckDebounce)
            guard !Task.isCancelled else { return }
            await self.checkNicknameAvailability()
        }
    }

    @MainActor
    private func checkNicknameAvailability() async {
        guard let availability = try? await profileRepository.checkNicknameAvailability(nickname) else { return }
        guard !Task.isCancelled else { return }
        lastCheckedNickname = nickname
        lastCheckedAvailability = availability
        isNicknameAvailable = availability.isAvailable
        nicknameCheckMessage = availability.message
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
            // 닉네임을 안 바꿨으면 중복 확인을 건너뛴다
            if nickname != originalNickname {
                let availability = try await profileRepository.checkNicknameAvailability(nickname)
                guard availability.isAvailable else {
                    isNicknameAvailable = false
                    nicknameCheckMessage = availability.message
                    return false
                }
            }
            // 새로 고른 사진이 없으면 nil을 보낸다
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
            originalNickname = nickname
            existingImageUrl = profile.profileImageUrl.flatMap(URL.init(string:))
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
