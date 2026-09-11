//
//  PostSummary.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//
import Foundation

struct PostSummary: Identifiable {
    let id: Int                 // 서버 게시글 id (상세조회/투표 연동에 필요)
    let type: VoteType
    let category: String
    let title: String
    let description: String     // 본문 미리보기 (커뮤니티 목록 카드용)
    let thumbnailUrl: URL?       // 대표 사진 1장. 일반 게시글은 null(API_SPEC 기준)
    // 커뮤니티 목록은 서버가 작성자 정보를 준다. 나의 활동 목록은 "항상 본인 글"이라 서버가
    // 아예 안 내려줘서(API_SPEC 기준) nil — 나의 활동 카드(MyActivityVotedPostCardView,
    // MyActivityWrittenPostCardView)는 애초에 작성자 정보를 그리지 않는다.
    let authorNickname: String?
    let authorLevel: Int?        // 뱃지 아이콘(PickpleLevelBadge1~5) 매핑용, 1~5 범위 가정 — 스펙 확정 후 조정
    let authorProfileImageUrl: URL?
    let voteCount: Int
    let commentCount: Int
    let createdAt: Date
    let voteResult: PostVoteResult?   // 나의 활동 > 투표 탭 전용 임시 필드. 실제 API 없어서 Mock에서만 채움.

    //추후 API 스펙에 맞게 수정

    init(
        id: Int,
        type: VoteType,
        category: String,
        title: String,
        description: String,
        thumbnailUrl: URL?,
        authorNickname: String? = nil,
        authorLevel: Int? = nil,
        authorProfileImageUrl: URL?,
        voteCount: Int,
        commentCount: Int,
        createdAt: Date,
        voteResult: PostVoteResult? = nil
    ) {
        self.id = id
        self.type = type
        self.category = category
        self.title = title
        self.description = description
        self.thumbnailUrl = thumbnailUrl
        self.authorNickname = authorNickname
        self.authorLevel = authorLevel
        self.authorProfileImageUrl = authorProfileImageUrl
        self.voteCount = voteCount
        self.commentCount = commentCount
        self.createdAt = createdAt
        self.voteResult = voteResult
    }
}

extension PostSummary {
    // GET /posts, GET /users/me/posts/recent, GET /users/me/activities 응답이 공통으로 갖는
    // 필드(카테고리 라벨 변환, 타입 변환, 썸네일 URL 파싱, voteCount 기본값 처리)를 한 곳에 모은다 —
    // 세 Repository가 각자 거의 같은 매핑 코드를 중복해서 갖고 있던 걸 정리한 것.
    static func fromServerFields(
        id: Int,
        type: String,
        category: String,
        title: String,
        description: String?,
        thumbnailUrl: String?,
        voteCount: Int?,
        commentCount: Int,
        createdAt: Date,
        authorNickname: String? = nil,
        authorLevel: Int? = nil,
        authorProfileImageUrl: URL? = nil,
        voteResult: PostVoteResult? = nil
    ) -> PostSummary {
        PostSummary(
            id: id,
            type: VoteType(serverType: type),
            category: PostCategoryLabel.label(for: category),
            title: title,
            description: description ?? "",
            thumbnailUrl: thumbnailUrl.flatMap(URL.init(string:)),
            authorNickname: authorNickname,
            authorLevel: authorLevel,
            authorProfileImageUrl: authorProfileImageUrl,
            voteCount: voteCount ?? 0,
            commentCount: commentCount,
            createdAt: createdAt,
            voteResult: voteResult
        )
    }

    // 목록 조회로는 voteResult가 안 채워져서(스펙에 없음), 상세 조회로 얻은 값을 나중에
    // 채워 넣을 때 쓰는 복사본 생성 헬퍼.
    func withVoteResult(_ voteResult: PostVoteResult?) -> PostSummary {
        PostSummary(
            id: id,
            type: type,
            category: category,
            title: title,
            description: description,
            thumbnailUrl: thumbnailUrl,
            authorNickname: authorNickname,
            authorLevel: authorLevel,
            authorProfileImageUrl: authorProfileImageUrl,
            voteCount: voteCount,
            commentCount: commentCount,
            createdAt: createdAt,
            voteResult: voteResult
        )
    }
}
