//
//  RemotePostDetailRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/9/26.
//

import Foundation

private struct ProductItemDTO: Decodable {
    let id: Int
    let name: String
    let price: Int?
    let linkUrl: String?
    let imageUrl: String?
    let displayOrder: Int
}

private struct OptionItemDTO: Decodable {
    let optionId: Int
    let label: String?
    let productId: Int?
    let displayOrder: Int
    // 투표하지 않았으면 서버 응답에서 이 두 필드 자체가 빠진다.
    let voteCount: Int?
    let percentage: Int?
}

private struct VoteSectionDTO: Decodable {
    let voted: Bool
    let selectedOptionId: Int?
    let voterCount: Int
    let products: [ProductItemDTO]
    let options: [OptionItemDTO]
}

private struct PostDetailResponseDTO: Decodable {
    let id: Int
    let type: String
    let category: String
    let title: String
    let description: String?
    let createdAt: Date
    let commentCount: Int
    let authorId: Int
    let authorNickname: String
    let authorProfileImageUrl: String?
    let authorGradeLevel: Int
    let authorGradeName: String
    let authorRanking: Int?
    let mine: Bool
    let vote: VoteSectionDTO?
}

struct RemotePostDetailRepository: PostDetailRepository {
    let apiClient: APIClientProtocol
    let postId: Int

    func fetchPostDetail() async throws -> PostDetail {
        let endpoint = APIEndpoint(method: .get, path: "/posts/\(postId)", attachesAuthIfAvailable: true)
        let dto: PostDetailResponseDTO = try await apiClient.request(endpoint)
        return Self.toDomain(dto)
    }

    func deletePost() async throws {
        let endpoint = APIEndpoint(method: .delete, path: "/posts/\(postId)", requiresAuth: true)
        try await apiClient.requestVoid(endpoint)
    }

    private static func toDomain(_ dto: PostDetailResponseDTO) -> PostDetail {
        PostDetail(
            id: dto.id,
            type: VoteType(serverType: dto.type),
            category: PostCategoryLabel.label(for: dto.category),
            title: dto.title,
            description: dto.description ?? "",
            createdAt: dto.createdAt,
            commentCount: dto.commentCount,
            authorId: dto.authorId,
            authorNickname: dto.authorNickname,
            authorProfileImageUrl: dto.authorProfileImageUrl.flatMap(URL.init(string:)),
            authorGradeLevel: dto.authorGradeLevel,
            authorGradeName: dto.authorGradeName,
            authorRanking: dto.authorRanking,
            isMine: dto.mine,
            vote: dto.vote.map { toDomain($0) }
        )
    }

    private static func toDomain(_ dto: VoteSectionDTO) -> PostDetailVote {
        PostDetailVote(
            voted: dto.voted,
            selectedOptionId: dto.selectedOptionId,
            voterCount: dto.voterCount,
            products: dto.products.map { toDomain($0) },
            options: dto.options.map { toDomain($0) }
        )
    }

    private static func toDomain(_ dto: ProductItemDTO) -> PostDetailProduct {
        PostDetailProduct(
            id: dto.id,
            name: dto.name,
            price: dto.price,
            purchaseURL: dto.linkUrl,
            imageUrl: dto.imageUrl.flatMap(URL.init(string:)),
            displayOrder: dto.displayOrder
        )
    }

    private static func toDomain(_ dto: OptionItemDTO) -> PostDetailVoteOption {
        PostDetailVoteOption(
            optionId: dto.optionId,
            label: dto.label,
            productId: dto.productId,
            displayOrder: dto.displayOrder,
            voteCount: dto.voteCount,
            percentage: dto.percentage
        )
    }
}
