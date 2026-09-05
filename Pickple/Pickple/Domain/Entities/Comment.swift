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
    let authorLevel: Int         // 서버가 댓글 작성자 등급은 안 줘서 1로 고정(다른 화면과 동일한 임시 처리)
    let authorProfileImageUrl: URL?
    let content: String
    let createdAt: Date
    var pickCount: Int = 0
    let mine: Bool                // 서버가 판정해서 주는 값 — 수정/삭제 가능 여부에 그대로 씀
}
