//
//  ProfileSetupViewModelTests.swift
//  PickpleTests
//

import XCTest
import UIKit
@testable import Pickple

private final class SpyProfileRepository: ProfileRepository {
    private(set) var uploadedImages: [UIImage] = []
    private(set) var registeredCalls: [(nickname: String, profileImageUrl: String?)] = []
    private(set) var updatedCalls: [(nickname: String, profileImageUrl: String?)] = []

    var uploadResult: Result<String, Error> = .success("https://cdn.pickple.app/profile/uploaded.jpg")
    var availability = NicknameAvailability(isAvailable: true, message: "사용 가능한 닉네임")

    func fetchMyProfile() async throws -> UserProfile {
        UserProfile(userId: 1, nickname: "picker", profileImageUrl: nil)
    }

    func checkNicknameAvailability(_ nickname: String) async throws -> NicknameAvailability {
        availability
    }

    func uploadProfileImage(_ image: UIImage) async throws -> String {
        uploadedImages.append(image)
        return try uploadResult.get()
    }

    func registerProfile(nickname: String, profileImageUrl: String?) async throws {
        registeredCalls.append((nickname, profileImageUrl))
    }

    func updateProfile(nickname: String, profileImageUrl: String?) async throws {
        updatedCalls.append((nickname, profileImageUrl))
    }
}

private func makeTestImage() -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 2, height: 2))
    return renderer.image { context in
        UIColor.red.setFill()
        context.fill(CGRect(x: 0, y: 0, width: 2, height: 2))
    }
}

@MainActor
final class ProfileSetupViewModelTests: XCTestCase {

    func test_submitProfile_withoutNewImage_registersWithNilImageURL() async {
        let spy = SpyProfileRepository()
        let viewModel = ProfileSetupViewModel(profileRepository: spy)
        viewModel.nickname = "picker"

        let succeeded = await viewModel.submitProfile()

        XCTAssertTrue(succeeded)
        XCTAssertEqual(spy.uploadedImages.count, 0)
        XCTAssertEqual(spy.registeredCalls.count, 1)
        XCTAssertEqual(spy.registeredCalls.first?.nickname, "picker")
        XCTAssertNil(spy.registeredCalls.first?.profileImageUrl)
    }

    func test_submitProfile_withNewImage_uploadsThenRegistersWithReturnedURL() async {
        let spy = SpyProfileRepository()
        spy.uploadResult = .success("https://cdn.pickple.app/profile/new.jpg")
        let viewModel = ProfileSetupViewModel(profileRepository: spy)
        viewModel.nickname = "picker"
        viewModel.setSelectedImage(makeTestImage())

        let succeeded = await viewModel.submitProfile()

        XCTAssertTrue(succeeded)
        XCTAssertEqual(spy.uploadedImages.count, 1)
        XCTAssertEqual(spy.registeredCalls.first?.profileImageUrl, "https://cdn.pickple.app/profile/new.jpg")
    }

    func test_submitProfile_whenUploadFails_doesNotRegisterAndSetsErrorMessage() async {
        struct UploadError: Error {}
        let spy = SpyProfileRepository()
        spy.uploadResult = .failure(UploadError())
        let viewModel = ProfileSetupViewModel(profileRepository: spy)
        viewModel.nickname = "picker"
        viewModel.setSelectedImage(makeTestImage())

        let succeeded = await viewModel.submitProfile()

        XCTAssertFalse(succeeded)
        XCTAssertEqual(spy.uploadedImages.count, 1)
        XCTAssertEqual(spy.registeredCalls.count, 0)
        XCTAssertNotNil(viewModel.errorMessage)
    }

    func test_submitProfile_whenNicknameDuplicate_failsAndMarksTextFieldError() async {
        let spy = SpyProfileRepository()
        spy.availability = NicknameAvailability(isAvailable: false, message: "이미 사용 중인 닉네임이에요")
        let viewModel = ProfileSetupViewModel(profileRepository: spy)
        viewModel.nickname = "picker"

        let succeeded = await viewModel.submitProfile()

        XCTAssertFalse(succeeded)
        XCTAssertEqual(spy.registeredCalls.count, 0)
        XCTAssertEqual(viewModel.isNicknameAvailable, false)
        XCTAssertEqual(viewModel.nicknameCheckMessage, "이미 사용 중인 닉네임이에요")
    }

    func test_nicknameDidChange_whenAvailable_enablesConfirmAfterDebounce() async {
        let spy = SpyProfileRepository()
        spy.availability = NicknameAvailability(isAvailable: true, message: "사용 가능한 닉네임")
        let viewModel = ProfileSetupViewModel(profileRepository: spy)

        viewModel.nickname = "picker"
        viewModel.nicknameDidChange()
        // ProfileSetupViewModel.nicknameCheckDebounce(500ms)보다 넉넉히 길게 기다린다 —
        // 짧으면 디바운스가 끝나기 전에 검증해버려 간헐적으로 실패한다.
        try? await Task.sleep(for: .milliseconds(700))

        XCTAssertEqual(viewModel.isNicknameAvailable, true)
    }

    func test_nicknameDidChange_whenDuplicate_marksErrorAndKeepsConfirmDisabled() async {
        let spy = SpyProfileRepository()
        spy.availability = NicknameAvailability(isAvailable: false, message: "이미 사용 중인 닉네임이에요")
        let viewModel = ProfileSetupViewModel(profileRepository: spy)

        viewModel.nickname = "picker"
        viewModel.nicknameDidChange()
        try? await Task.sleep(for: .milliseconds(700))

        XCTAssertEqual(viewModel.isNicknameAvailable, false)
        XCTAssertEqual(viewModel.nicknameCheckMessage, "이미 사용 중인 닉네임이에요")
    }

    func test_nicknameDidChange_whenUnchangedFromOriginal_skipsNetworkCheck() async {
        let spy = SpyProfileRepository()
        let viewModel = ProfileSetupViewModel(profileRepository: spy)
        await viewModel.loadCurrentProfile()   // originalNickname = "picker" (SpyProfileRepository 기준)

        viewModel.nicknameDidChange()

        XCTAssertEqual(viewModel.isNicknameAvailable, true)
    }

    func test_updateProfile_withNewImage_uploadsThenUpdatesWithReturnedURL() async {
        let spy = SpyProfileRepository()
        spy.uploadResult = .success("https://cdn.pickple.app/profile/updated.jpg")
        let viewModel = ProfileSetupViewModel(profileRepository: spy)
        viewModel.nickname = "picker"
        viewModel.setSelectedImage(makeTestImage())

        let succeeded = await viewModel.updateProfile()

        XCTAssertTrue(succeeded)
        XCTAssertEqual(spy.uploadedImages.count, 1)
        XCTAssertEqual(spy.updatedCalls.first?.profileImageUrl, "https://cdn.pickple.app/profile/updated.jpg")
    }
}
