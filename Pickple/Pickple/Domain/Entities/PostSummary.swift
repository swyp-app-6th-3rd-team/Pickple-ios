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
    let authorNickname: String  // 나의 활동(투표/댓글) 목록에서는 남의 글일 수 있어 필요
    let authorLevel: Int        // 뱃지 아이콘(PickpleLevelBadge1~5) 매핑용, 1~5 범위 가정 — 스펙 확정 후 조정
    let authorProfileImageUrl: URL?
    let voteCount: Int
    let commentCount: Int
    let createdAt: Date

    //추후 API 스펙에 맞게 수정
}
