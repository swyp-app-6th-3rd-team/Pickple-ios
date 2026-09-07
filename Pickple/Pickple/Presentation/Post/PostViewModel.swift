//
//  PostViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 8/29/26.
//

import Foundation
import UIKit

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

    var hasPhoto: Bool { !photos.isEmpty }
    var hasName: Bool { !name.trimmingCharacters(in: .whitespaces).isEmpty }

    var isValid: Bool {
        hasPhoto && hasName
    }

    var writeDraft: PostWriteProductDraft {
        PostWriteProductDraft(photos: photos, name: name, price: Int(price), linkUrl: url.isEmpty ? nil : url)
    }
}

enum PostSubmitState: Equatable {
    case idle
    case submitting
    case succeeded
    case failed
}

@Observable
class PostViewModel {
    private let postWriteRepository: PostWriteRepository

    var selectedType: VoteType = .forAgainst
    var topic: String = ""
    var title: String = ""
    var description: String = ""
    var selectedCategory: String = PostViewStrings.categoryPlaceholder

    // 찬반 픽 상품 정보
    var product = PostProductDraft()
    // 비교 픽 상품 정보 (A/B)
    var productA = PostProductDraft()
    var productB = PostProductDraft()

    var submitState: PostSubmitState = .idle

    let topicMaxLength = 30
    let titleMaxLength = 30
    let descriptionMaxLength = 300
    let productNameMaxLength = 30

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

    // 설명은 모든 유형에서 선택 입력이라 필수값 체크에 포함하지 않는다.
    private var isBasicInfoValid: Bool {
        switch selectedType {
        case .forAgainst:
            return isCategorySelected
        case .ab:
            return isCategorySelected && !topic.trimmingCharacters(in: .whitespaces).isEmpty
        case .text:
            return isCategorySelected && !title.trimmingCharacters(in: .whitespaces).isEmpty
        }
    }

    // 한 화면에 모든 입력을 합쳤으므로, 이 화면의 필수 항목이 전부 채워졌는지가 곧 게시 가능 여부다.
    var canSubmit: Bool {
        switch selectedType {
        case .forAgainst:
            return isBasicInfoValid && product.isValid
        case .ab:
            return isBasicInfoValid && productA.isValid && productB.isValid
        case .text:
            return isBasicInfoValid
        }
    }

    // 상단 게이지에 쓰는 필수 항목 채움 개수. 설명/가격/URL 같은 선택 입력은 세지 않는다.
    var requiredFieldsFilledCount: Int {
        switch selectedType {
        case .forAgainst:
            return [isCategorySelected, product.hasPhoto, product.hasName].filter { $0 }.count
        case .ab:
            return [isCategorySelected, isTopicFilled, productA.hasPhoto, productA.hasName, productB.hasPhoto, productB.hasName].filter { $0 }.count
        case .text:
            return [isCategorySelected, isTitleFilled].filter { $0 }.count
        }
    }

    var requiredFieldsTotalCount: Int {
        switch selectedType {
        case .forAgainst: return 3
        case .ab: return 6
        case .text: return 2
        }
    }

    var isTopicFilled: Bool {
        !topic.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var isTitleFilled: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
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

    // 찬반은 서버가 첫 상품명으로 title을 자동 결정하므로 보내지 않는다.
    private var submittedTitle: String? {
        switch selectedType {
        case .forAgainst: return nil
        case .ab: return topic
        case .text: return title
        }
    }

    private var submittedProducts: [PostWriteProductDraft] {
        switch selectedType {
        case .forAgainst: return [product.writeDraft]
        case .ab: return [productA.writeDraft, productB.writeDraft]
        case .text: return []
        }
    }

    init(postWriteRepository: PostWriteRepository = MockPostWriteRepository()) {
        self.postWriteRepository = postWriteRepository
    }

    @MainActor
    func submitPost() async {
        submitState = .submitting
        do {
            _ = try await postWriteRepository.createPost(
                type: selectedType,
                category: selectedCategory,
                title: submittedTitle,
                description: description.isEmpty ? nil : description,
                products: submittedProducts
            )
            submitState = .succeeded
        } catch {
            submitState = .failed
        }
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
