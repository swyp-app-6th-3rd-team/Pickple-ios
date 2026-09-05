//
//  RemoteUserPostRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/5/26.
//

import Foundation

struct ActivityItemDTO: Decodable {
    let id: Int
    let type: String
    let category: String
    let title: String
    let description: String?
    let commentCount: Int
    let voteCount: Int?
    let thumbnailUrl: String?
    let createdAt: Date
}

// GET /users/me/posts/recent만 있고 투표/댓글/작성 글을 각각 조회하는 API는 아직 없어서,
// fetchVotedPosts/fetchCommentedPosts/fetchWrittenPosts는 MockUserPostRepository에 위임한다.
struct RemoteUserPostRepository: UserPostRepository {
    let apiClient: APIClientProtocol
    private let fallback = MockUserPostRepository()

    func fetchMyPosts() async throws -> [PostSummary] {
        let endpoint = APIEndpoint(method: .get, path: "/users/me/posts/recent", requiresAuth: true)
        let dtos: [ActivityItemDTO] = try await apiClient.request(endpoint)
        return dtos.map(Self.toDomain)
    }

    func fetchVotedPosts() async -> [PostSummary] {
        await fallback.fetchVotedPosts()
    }

    func fetchCommentedPosts() async -> [PostSummary] {
        await fallback.fetchCommentedPosts()
    }

    func fetchWrittenPosts() async -> [PostSummary] {
        await fallback.fetchWrittenPosts()
    }

    private static func toDomain(_ dto: ActivityItemDTO) -> PostSummary {
        PostSummary(
            id: UUID(),
            type: voteType(for: dto.type),
            category: categoryLabel(for: dto.category),
            title: dto.title,
            description: dto.description ?? "",
            imageName: dto.thumbnailUrl ?? "",
            // "내가 올린 글" 목록이라 서버가 작성자 정보를 따로 안 준다(본인이 자명해서) —
            // 실제 내 닉네임/레벨로 채우려면 별도로 내 프로필을 조회해서 합쳐야 한다. 이번 범위 밖.
            authorNickname: "나",
            authorLevel: 1,
            authorProfileImageName: nil,
            voteCount: dto.voteCount ?? 0,
            commentCount: dto.commentCount,
            createdAt: dto.createdAt
        )
    }

    private static func voteType(for rawType: String) -> VoteType {
        switch rawType {
        case "AGREE": return .forAgainst
        case "A_B": return .ab
        default: return .text
        }
    }

    private static func categoryLabel(for rawCategory: String) -> String {
        switch rawCategory {
        case "FASHION": return "패션/잡화"
        case "ELECTRONICS": return "전자제품"
        case "BEAUTY": return "뷰티"
        case "LIVING": return "생활용품"
        default: return "기타"
        }
    }
}
