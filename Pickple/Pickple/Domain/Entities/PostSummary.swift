//
//  PostSummary.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//
import Foundation

struct PostSummary: Identifiable {
    let id: UUID
    let type: VoteType
    let category: String
    let title: String
    let imageName: String       // 미리보기 썸네일 (여러 장 중 첫 장)
    let authorNickname: String  // 나의 활동(투표/댓글) 목록에서는 남의 글일 수 있어 필요
    let authorLevel: Int        // 뱃지 아이콘(PickpleLevelBadge1~5) 매핑용, 1~5 범위 가정 — 스펙 확정 후 조정
    let voteCount: Int
    let commentCount: Int
    let createdAt: Date

    //추후 API 스펙에 맞게 수정
}
