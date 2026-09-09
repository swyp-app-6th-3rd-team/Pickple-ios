//
//  RemoteVoteCardRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/5/26.
//

import Foundation

private struct PostRandomProductDTO: Decodable {
    let productId: Int?
    let name: String?
    let displayOrder: Int?
    let imageUrl: String?
}

private struct PostRandomOptionDTO: Decodable {
    let optionId: Int?
    let label: String?
    let productId: Int?
    let displayOrder: Int?
    let voteCount: Int?
    let percentage: Int?
}

private struct PostRandomItemDTO: Decodable {
    let id: Int
    let type: String
    let title: String?
    let description: String?
    let voterCount: Int?
    let selectedOptionId: Int?
    let products: [PostRandomProductDTO]?
    let options: [PostRandomOptionDTO]?
}

private struct PostRandomResponseDTO: Decodable {
    let content: [PostRandomItemDTO]
    let nextCursor: String?
    let hasNext: Bool
}

private struct VoteOptionDTO: Decodable {
    let optionId: Int?
    let label: String?
    let displayOrder: Int?
    let voteCount: Int?
    let percentage: Int?
}

private struct VoteResponseDTO: Decodable {
    let postId: Int?
    let selectedOptionId: Int?
    let voterCount: Int?
    let options: [VoteOptionDTO]?
}

private struct CastVoteRequestDTO: Encodable {
    let optionId: Int
}

struct RemoteVoteCardRepository: VoteCardRepository {
    let apiClient: APIClientProtocol

    // 홈 카드스택은 찬반/AB 픽만 스와이프 대상이라(일반 글 제외), GET /posts/random으로
    // 유형별로 따로 호출한다 — GET /posts 기반 구현과 달리 서버가 진짜 임의 순서를 주고,
    // 투표에 필요한 optionId와 AB 두 번째 상품 사진도 여기서 온다(GET /posts는 둘 다 없었음).
    func fetchCards(type: VoteType) async throws -> [VoteCard] {
        let endpoint = APIEndpoint(
            method: .get,
            path: "/posts/random",
            queryItems: [URLQueryItem(name: "type", value: type.serverTypeValue)],
            attachesAuthIfAvailable: true
        )
        let response: PostRandomResponseDTO = try await apiClient.request(endpoint)
        return response.content.map(Self.toDomain)
    }

    func castVote(postId: Int, optionId: Int) async throws -> (firstPercentage: Int, secondPercentage: Int) {
        let body = try JSONEncoder().encode(CastVoteRequestDTO(optionId: optionId))
        let endpoint = APIEndpoint(method: .post, path: "/posts/\(postId)/votes", body: body, requiresAuth: true)
        let response: VoteResponseDTO = try await apiClient.request(endpoint)

        let options = (response.options ?? []).sorted { ($0.displayOrder ?? 0) < ($1.displayOrder ?? 0) }
        let first = options.first?.percentage ?? 0
        // 반올림 때문에 두 값의 합이 100이 아닐 수 있다(API_SPEC.md 명시) — 두 번째 옵션 응답이
        // 없거나 이상해도 게이지가 항상 100%를 채우도록 나머지로 보정한다.
        let second = options.count > 1 ? options[1].percentage ?? (100 - first) : 100 - first
        return (first, second)
    }

    private static func toDomain(_ dto: PostRandomItemDTO) -> VoteCard {
        let sortedOptions = (dto.options ?? []).sorted { ($0.displayOrder ?? 0) < ($1.displayOrder ?? 0) }
        let sortedProducts = (dto.products ?? []).sorted { ($0.displayOrder ?? 0) < ($1.displayOrder ?? 0) }

        let isVoted = dto.selectedOptionId != nil
        let firstPercentage = sortedOptions.first?.percentage
        let secondPercentage = sortedOptions.count > 1 ? sortedOptions[1].percentage : nil

        return VoteCard(
            id: dto.id,
            type: VoteType(serverType: dto.type),
            productName: dto.title ?? "",
            concernText: dto.description ?? "",
            imageUrl: sortedProducts.first?.imageUrl.flatMap(URL.init(string:)),
            secondImageUrl: sortedProducts.count > 1 ? sortedProducts[1].imageUrl.flatMap(URL.init(string:)) : nil,
            participantCount: dto.voterCount ?? 0,
            firstOptionId: sortedOptions.first?.optionId,
            secondOptionId: sortedOptions.count > 1 ? sortedOptions[1].optionId : nil,
            firstPercentage: isVoted ? (firstPercentage ?? 0) : nil,
            secondPercentage: isVoted ? (secondPercentage ?? 0) : nil
        )
    }
}
