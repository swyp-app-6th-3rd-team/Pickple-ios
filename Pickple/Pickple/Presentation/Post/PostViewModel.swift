//
//  PostViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 8/29/26.
//

import Foundation
import Combine
import UIKit

enum VoteType: Equatable {
    case forAgainst
    case ab
    case text
}

extension VoteType {
    var displayName: String {
        switch self {
        case .forAgainst: return PostViewStrings.forAgainstPickTitle
        case .ab: return PostViewStrings.abPickTitle
        case .text: return PostViewStrings.textPickTitle
        }
    }
}

struct PostProductDraft {
    var photos: [UIImage] = []
    var name: String = ""
    var price: String = ""
    var url: String = ""

    var isValid: Bool {
        !photos.isEmpty && !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

enum PostSubmitState: Equatable {
    case idle
    case submitting
    case succeeded
    case failed
}

class PostViewModel: ObservableObject {
    @Published var selectedType: VoteType = .forAgainst
    @Published var topic: String = ""
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var selectedCategory: String = PostViewStrings.categoryPlaceholder

    // 찬반 픽 상품 정보
    @Published var product = PostProductDraft()
    // 비교 픽 상품 정보 (A/B)
    @Published var productA = PostProductDraft()
    @Published var productB = PostProductDraft()

    @Published var submitState: PostSubmitState = .idle
    @Published var currentIndex = 0

    let topicMaxLength = 30
    let titleMaxLength = 30
    let descriptionMaxLength = 300
    let productNameMaxLength = 30

    var totalSteps: Int {
        switch selectedType {
        case .forAgainst: return 2
        case .ab: return 3
        case .text: return 1
        }
    }

    var isCategorySelected: Bool {
        selectedCategory != PostViewStrings.categoryPlaceholder
    }

    var gnbTitle: String {
        switch selectedType {
        case .forAgainst: return PostViewStrings.forAgainstWriteTitle
        case .ab: return PostViewStrings.abWriteTitle
        case .text: return PostViewStrings.textWriteTitle
        }
    }

    var isLastStep: Bool {
        currentIndex >= totalSteps - 1
    }

    // 설명은 모든 유형에서 선택 입력이라 필수값 체크에 포함하지 않는다.
    var isStepOneValid: Bool {
        switch selectedType {
        case .forAgainst:
            return isCategorySelected
        case .ab:
            return isCategorySelected && !topic.trimmingCharacters(in: .whitespaces).isEmpty
        case .text:
            return isCategorySelected && !title.trimmingCharacters(in: .whitespaces).isEmpty
        }
    }

    // 마지막 단계까지 포함해 게시(submit) 가능한 상태인지
    var canSubmit: Bool {
        switch selectedType {
        case .forAgainst:
            return isStepOneValid && product.isValid
        case .ab:
            return isStepOneValid && productA.isValid && productB.isValid
        case .text:
            return isStepOneValid
        }
    }

    var isCurrentStepValid: Bool {
        currentIndex == 0 ? isStepOneValid : canSubmit
    }

    // 작성 중인 내용이 하나라도 있으면 나가기 확인이 필요하다고 판단
    var hasDraftContent: Bool {
        isCategorySelected
            || !topic.isEmpty
            || !title.isEmpty
            || !description.isEmpty
            || !product.photos.isEmpty
            || !product.name.isEmpty
            || !productA.photos.isEmpty
            || !productA.name.isEmpty
            || !productB.photos.isEmpty
            || !productB.name.isEmpty
    }

    func isSelected(_ type: VoteType) -> Bool {
        selectedType == type
    }

    func moveToPreviousStep() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
    }

    func moveToNextStep() {
        guard !isLastStep else { return }
        currentIndex += 1
    }

    // TODO: 실제 게시글 등록 API 연동 필요 — 지금은 항상 성공하는 Mock
    @MainActor
    func submitPost() async {
        submitState = .submitting
        try? await Task.sleep(nanoseconds: 500_000_000)
        submitState = .succeeded
    }
}

extension PostViewModel {
    // 게시글 상세의 "수정하기"에서 기존 내용을 채운 채로 작성 화면을 열기 위한 팩토리.
    // TODO: 실제로는 서버가 내려주는 원본 데이터(원본 사진 포함)로 채워야 함 — 지금은 Mock 상세 데이터 기준
    static func editing(_ post: PostDetail) -> PostViewModel {
        let viewModel = PostViewModel()
        viewModel.selectedType = post.type
        viewModel.selectedCategory = post.category
        viewModel.description = post.description

        switch post.type {
        case .text:
            viewModel.title = post.title
        case .forAgainst:
            if let product = post.firstProduct {
                viewModel.product = PostProductDraft(
                    photos: post.images.compactMap { UIImage(named: $0) },
                    name: product.name,
                    price: String(product.price),
                    url: product.purchaseURL
                )
            }
        case .ab:
            viewModel.topic = post.title
            let firstImage = post.images.first.flatMap { UIImage(named: $0) }
            if let first = post.firstProduct {
                viewModel.productA = PostProductDraft(
                    photos: firstImage.map { [$0] } ?? [],
                    name: first.name,
                    price: String(first.price),
                    url: first.purchaseURL
                )
            }
            if let second = post.secondProduct {
                viewModel.productB = PostProductDraft(
                    photos: firstImage.map { [$0] } ?? [],
                    name: second.name,
                    price: String(second.price),
                    url: second.purchaseURL
                )
            }
        }

        return viewModel
    }
}
