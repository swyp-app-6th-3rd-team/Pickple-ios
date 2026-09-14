//
//  Comment.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Foundation

struct Comment: Identifiable {
    let id: Int                  // 서버 댓글 id (수정/삭제/원픽 연동에 필요)
    let authorNickname: String
    let authorLevel: Int         // 뱃지 아이콘(PickpleLevelBadge1~5) 매핑용. 서버 authorGradeLevel(2026-09-15 신규), 없으면 1
    let authorProfileImageUrl: URL?
    let content: String
    let createdAt: Date
    var pickCount: Int = 0
    let mine: Bool                // 서버가 판정해서 주는 값 — 수정/삭제 가능 여부에 그대로 씀
}
