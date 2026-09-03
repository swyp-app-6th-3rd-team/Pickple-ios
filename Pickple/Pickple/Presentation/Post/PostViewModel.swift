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
    case compare
    case text
}

extension VoteType {
    var displayName: String {
        switch self {
        case .forAgainst: return PostViewStrings.forAgainstPickTitle
        case .compare: return PostViewStrings.abPickTitle
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

    let topicMaxLength = 30
    let titleMaxLength = 30
    let descriptionMaxLength = 300
    let productNameMaxLength = 30

    var totalSteps: Int {
        switch selectedType {
        case .forAgainst: return 2
        case .compare: return 3
        case .text: return 1
        }
    }

    var isCategorySelected: Bool {
        selectedCategory != PostViewStrings.categoryPlaceholder
    }

    var isStepOneValid: Bool {
        let hasDescription = !description.trimmingCharacters(in: .whitespaces).isEmpty
        switch selectedType {
        case .forAgainst:
            return isCategorySelected && hasDescription
        case .compare:
            return isCategorySelected && !topic.trimmingCharacters(in: .whitespaces).isEmpty && hasDescription
        case .text:
            return isCategorySelected && !title.trimmingCharacters(in: .whitespaces).isEmpty && hasDescription
        }
    }

    // 마지막 단계까지 포함해 게시(submit) 가능한 상태인지
    var canSubmit: Bool {
        switch selectedType {
        case .forAgainst:
            return isStepOneValid && product.isValid
        case .compare:
            return isStepOneValid && productA.isValid && productB.isValid
        case .text:
            return isStepOneValid
        }
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

    // TODO: 실제 게시글 등록 API 연동 필요 — 지금은 항상 성공하는 Mock
    @MainActor
    func submitPost() async {
        submitState = .submitting
        try? await Task.sleep(nanoseconds: 500_000_000)
        submitState = .succeeded
    }
}
