//
//  RemoteUserPostRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/5/26.
//

import Foundation

// GET /users/me/posts/recent와 GET /users/me/activities/posts 둘 다 GET /posts의 content
// 항목과 같은 필드를 준다. 후자만 activityAt(내가 이 게시글에 활동한 시각)을 추가로 주는데,
// 전자엔 그 키 자체가 없어서 Optional로 두면 자연히 nil로 디코딩된다 — 두 응답이 같은
// 구조라 DTO 하나로 공유한다.
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
    let activityAt: Date?
}

private struct ActivityListResponseDTO: Decodable {
    let content: [ActivityItemDTO]
    let nextCursor: String?
    let hasNext: Bool
}

// GET /users/me/activities/votes 전용. 기본 필드(ActivityItemDTO와 동일 셋) + 투표 결과.
private struct VoteActivityOptionDTO: Decodable {
    let optionId: Int
    let displayOrder: Int
    let voteCount: Int
    let percentage: Int
}

private struct VoteActivityItemDTO: Decodable {
    let id: Int
    let type: String
    let category: String
    let title: String
    let description: String?
    let commentCount: Int
    let voteCount: Int?
    let thumbnailUrl: String?
    let createdAt: Date
    let activityAt: Date?
    let selectedOptionId: Int?
    let options: [VoteActivityOptionDTO]?
}

private struct VoteActivityListResponseDTO: Decodable {
    let content: [VoteActivityItemDTO]
    let nextCursor: String?
    let hasNext: Bool
}

// GET /users/me/activities/comments 전용. 기본 필드 + 대표 댓글(원픽 최다, 동률이면 최신 —
// 삭제된 댓글은 대표 후보에서 제외되는 걸 서버가 보장).
private struct CommentActivityItemDTO: Decodable {
    let id: Int
    let type: String
    let category: String
    let title: String
    let description: String?
    let commentCount: Int
    let voteCount: Int?
    let thumbnailUrl: String?
    let createdAt: Date
    let activityAt: Date?
    let myComment: String?
    let myCommentOnePickCount: Int?
}

private struct CommentActivityListResponseDTO: Decodable {
    let content: [CommentActivityItemDTO]
    let nextCursor: String?
    let hasNext: Bool
}

struct RemoteUserPostRepository: UserPostRepository {
    let apiClient: APIClientProtocol

    func fetchMyPosts() async throws -> [PostSummary] {
        let endpoint = APIEndpoint(method: .get, path: "/users/me/posts/recent", requiresAuth: true)
        let dtos: [ActivityItemDTO] = try await apiClient.request(endpoint)
        return dtos.map(Self.toDomain)
    }

    // 2026-09-13부터 GET /users/me/activities/votes가 selectedOptionId/options를 직접 줘서,
    // 게시글마다 상세를 따로 불러 채우던 N+1 워크어라운드가 필요 없어졌다.
    func fetchVotedPosts(cursor: String?) async -> UserPostPage {
        var queryItems: [URLQueryItem] = []
        if let cursor {
            queryItems.append(URLQueryItem(name: "cursor", value: cursor))
        }
        let endpoint = APIEndpoint(method: .get, path: "/users/me/activities/votes", queryItems: queryItems, requiresAuth: true)
        guard let response: VoteActivityListResponseDTO = try? await apiClient.request(endpoint) else {
            return UserPostPage(items: [], nextCursor: nil, hasNext: false)
        }
        return UserPostPage(items: response.content.map(Self.toDomain), nextCursor: response.nextCursor, hasNext: response.hasNext)
    }

    private static func voteResultLabels(for type: VoteType) -> (String, String) {
        type == .ab
            ? (MyActivityStrings.abFirstLabel, MyActivityStrings.abSecondLabel)
            : (MyActivityStrings.voteSideFor, MyActivityStrings.voteSideAgainst)
    }

    // 2026-09-13부터 GET /users/me/activities/comments가 대표 댓글(myComment)을 직접 줘서,
    // 게시글마다 댓글 목록을 따로 불러 mine==true를 거르던 N+1 워크어라운드가 필요 없어졌다.
    // 서버가 게시글당 대표 댓글 하나만 주므로(§3 동작 변경), 한 게시글에 내 댓글이 여러 개여도
    // 이제 한 줄로만 보인다 — 예전(댓글마다 한 줄)과 달라진 표시 단위다.
    func fetchCommentedPosts() async -> [MyCommentActivity] {
        var items: [MyCommentActivity] = []
        var cursor: String?
        while true {
            var queryItems: [URLQueryItem] = []
            if let cursor {
                queryItems.append(URLQueryItem(name: "cursor", value: cursor))
            }
            let endpoint = APIEndpoint(method: .get, path: "/users/me/activities/comments", queryItems: queryItems, requiresAuth: true)
            guard let response: CommentActivityListResponseDTO = try? await apiClient.request(endpoint) else { break }
            items += response.content.map(Self.toDomain)
            guard response.hasNext, let next = response.nextCursor else { break }
            cursor = next
        }
        return items
    }

    func fetchWrittenPosts(cursor: String?) async -> UserPostPage {
        var queryItems: [URLQueryItem] = []
        if let cursor {
            queryItems.append(URLQueryItem(name: "cursor", value: cursor))
        }
        let endpoint = APIEndpoint(method: .get, path: "/users/me/activities/posts", queryItems: queryItems, requiresAuth: true)
        guard let response: ActivityListResponseDTO = try? await apiClient.request(endpoint) else {
            return UserPostPage(items: [], nextCursor: nil, hasNext: false)
        }
        return UserPostPage(items: response.content.map(Self.toDomain), nextCursor: response.nextCursor, hasNext: response.hasNext)
    }

    // "내가 올린/투표한/작성한 글" 목록이라 서버가 작성자 정보를 따로 안 준다(항상 본인 글이라
    // 자명해서, API_SPEC 기준) — authorNickname/authorLevel은 nil로 두고, 화면 쪽에서 작성자
    // 정보를 아예 표시하지 않는다. activityAt이 없으면(=/users/me/posts/recent) createdAt을 쓴다.
    private static func toDomain(_ dto: ActivityItemDTO) -> PostSummary {
        .fromServerFields(
            id: dto.id,
            type: dto.type,
            category: dto.category,
            title: dto.title,
            description: dto.description,
            thumbnailUrl: dto.thumbnailUrl,
            voteCount: dto.voteCount,
            commentCount: dto.commentCount,
            createdAt: dto.activityAt ?? dto.createdAt
        )
    }

    // options는 항상 2개(displayOrder 1/2)라 R-04와 동일 전제. label은 A/B에서 null이라
    // 서버 값 대신 voteResultLabels(post.type 기준)로 클라이언트가 정한다(게시글 상세와 동일 관례).
    private static func toDomain(_ dto: VoteActivityItemDTO) -> PostSummary {
        var voteResult: PostVoteResult?
        if let selectedOptionId = dto.selectedOptionId,
           let options = dto.options,
           let first = options.first(where: { $0.displayOrder == 1 }),
           let second = options.first(where: { $0.displayOrder == 2 }) {
            let (firstLabel, secondLabel) = voteResultLabels(for: VoteType(serverType: dto.type))
            voteResult = PostVoteResult(
                firstLabel: firstLabel,
                secondLabel: secondLabel,
                firstPercentage: first.percentage,
                secondPercentage: second.percentage,
                votedSide: selectedOptionId == first.optionId ? .first : .second
            )
        }
        return .fromServerFields(
            id: dto.id,
            type: dto.type,
            category: dto.category,
            title: dto.title,
            description: dto.description,
            thumbnailUrl: dto.thumbnailUrl,
            voteCount: dto.voteCount,
            commentCount: dto.commentCount,
            createdAt: dto.activityAt ?? dto.createdAt,
            voteResult: voteResult
        )
    }

    private static func toDomain(_ dto: CommentActivityItemDTO) -> MyCommentActivity {
        MyCommentActivity(
            id: dto.id,
            content: dto.myComment ?? "",
            pickCount: dto.myCommentOnePickCount ?? 0,
            createdAt: dto.activityAt ?? dto.createdAt,
            referencedPost: MyCommentActivityPostReference(
                id: dto.id,
                type: VoteType(serverType: dto.type),
                title: dto.title,
                thumbnailUrl: dto.thumbnailUrl.flatMap(URL.init(string:)),
                voteCount: dto.voteCount ?? 0,
                commentCount: dto.commentCount
            )
        )
    }
}
