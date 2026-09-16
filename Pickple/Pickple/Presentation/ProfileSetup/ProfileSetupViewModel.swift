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
    // 닉네임을 입력할 때마다(nicknameDidChange) 서버 중복확인이 실패하면 세팅한다.
    // 닉네임을 다시 입력하면 resetNicknameDuplicateState()로 리셋되어 재확인 전까지
    // 화면에 남지 않는다.
    var isNicknameDuplicate = false
    var nicknameDuplicateMessage: String?
    // 서버가 "사용 가능"이라고 확인해준 상태에만 true — 확인 버튼은 이 값을 보고 활성화된다.
    var isNicknameAvailable = false
    // 중복확인 요청이 아직 응답을 기다리는 중인지 — 텍스트필드에 "작성중" 상태를 보여주는 데 쓴다.
    var isCheckingNickname = false
    // 입력이 바뀔 때마다 이전 요청을 취소하고 새로 확인한다(디바운스 없이 매 입력마다 바로 요청).
    private var nicknameCheckTask: Task<Void, Never>?

    let nicknameMaxLength = 5
    private let profileRepository: ProfileRepository
    // 수정 화면 진입 시 loadCurrentProfile()로 불러온 원래 닉네임. 중복 확인을 건너뛸지
    // 판단하는 기준으로만 쓴다(신규 등록 플로우에서는 nil로 남아 항상 검사한다).
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
    
    func textFieldState(_ isFocused: Bool) -> PickpleTextFieldStateType {
        if isCheckingNickname { return .ing }
        if isNicknameDuplicate { return .error }
        if isNicknameAvailable { return .success }
        if isFocused && nickname.isEmpty { return .select }
        return ._default
    }

    func nicknameCaption(_ state: PickpleTextFieldStateType) -> String {
        switch state {
        case .error: return nicknameDuplicateMessage ?? ProfileSetupStrings.error
        case .success: return ProfileSetupStrings.success
        default: return ""
        }
    }

    // 닉네임을 다시 입력하기 시작하면 이전 중복확인 결과는 더 이상 유효하지 않으므로 지운다.
    func resetNicknameDuplicateState() {
        isNicknameDuplicate = false
        nicknameDuplicateMessage = nil
    }

    // 텍스트필드가 바뀔 때마다(키 입력마다) 호출된다. 디바운스 없이 바로 중복확인을 실행하되,
    // 이전 요청이 아직 응답을 안 받았으면 취소하고 새 값으로 다시 요청한다(응답이 입력 순서와
    // 다르게 도착해서 최신 입력값 결과를 옛날 응답이 덮어쓰는 걸 방지).
    @MainActor
    func nicknameDidChange() {
        resetNicknameDuplicateState()
        isNicknameAvailable = false
        nicknameCheckTask?.cancel()

        guard isNicknameValid() else { return }

        // 본인이 원래 쓰던 닉네임 그대로면 중복확인을 건너뛴다 — GET /users/nickname/availability는
        // 익명 조회라 서버가 "지금 이 닉네임의 주인이 나"라는 걸 몰라서, 안 바뀐 본인 닉네임도
        // "이미 사용 중"으로 판정해버린다.
        if nickname == originalNickname {
            isNicknameAvailable = true
            return
        }

        nicknameCheckTask = Task { [weak self] in
            await self?.checkNicknameAvailability()
        }
    }

    @MainActor
    private func checkNicknameAvailability() async {
        guard !Task.isCancelled else { return }
        isCheckingNickname = true
        defer { isCheckingNickname = false }
        guard let availability = try? await profileRepository.checkNicknameAvailability(nickname) else { return }
        guard !Task.isCancelled else { return }
        print("[닉네임 중복확인] \"\(nickname)\" -> \(availability.isAvailable ? "사용 가능" : "중복") (message: \(availability.message))")
        if availability.isAvailable {
            isNicknameAvailable = true
        } else {
            isNicknameDuplicate = true
            nicknameDuplicateMessage = availability.message
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
                print("[닉네임 중복확인] \"\(nickname)\" -> \(availability.isAvailable ? "사용 가능" : "중복") (message: \(availability.message))")
                guard availability.isAvailable else {
                    isNicknameDuplicate = true
                    nicknameDuplicateMessage = availability.message
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
