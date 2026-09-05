//
//  RemoteVoteCardRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/5/26.
//

import Foundation

struct RemoteVoteCardRepository: VoteCardRepository {
    let apiClient: APIClientProtocol

    // 홈 카드스택은 찬반/AB 픽만 스와이프 대상이라(일반 글 제외), GET /posts 결과에서
    // type이 GENERAL(.text)인 항목은 걸러낸다.
    func fetchCards() async throws -> [VoteCard] {
        let endpoint = APIEndpoint(method: .get, path: "/posts", requiresAuth: false)
        let dto: PostScrollDTO = try await apiClient.request(endpoint)
        return dto.content
            .filter { $0.type != "GENERAL" }
            .map(Self.toDomain)
    }

    // TODO: 게시글 목록 API는 대표 사진 1장만 줘서 AB 카드의 두 번째 사진(secondImageUrl)은
    // 항상 nil이다 — 게시글 상세조회 API가 생기면 그때 채운다.
    // 투표 전 통계 블라인드 규칙(CLAUDE.md)에 따라 firstPercentage/secondPercentage는
    // 항상 nil로 시작하고, 실제 투표 참여 연동 시 응답으로 채운다.
    static func toDomain(_ dto: PostListItemDTO) -> VoteCard {
        VoteCard(
            id: dto.id,
            type: VoteType(serverType: dto.type),
            productName: dto.title,
            concernText: dto.description ?? "",
            imageUrl: dto.thumbnailUrl.flatMap(URL.init(string:)),
            secondImageUrl: nil,
            participantCount: dto.voteCount ?? 0,
            firstPercentage: nil,
            secondPercentage: nil
        )
    }
}
