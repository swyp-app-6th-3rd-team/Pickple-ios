//
//  MyCommentActivity.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  '나의 활동 > 댓글' 탭 전용. Comment(단일 게시글 스레드 안의 댓글)와 달리
//  여러 게시글에 걸친 내 댓글 목록이라 참조 게시글 정보를 함께 들고 있어야 한다.
//  TODO: 내가 작성한 댓글 목록을 조회하는 API가 스펙에 없어서 아직 Mock — API 나오면 연동

import Foundation

struct MyCommentActivity: Identifiable {
    let id: Int
    let content: String
    let pickCount: Int
    let createdAt: Date
    let referencedPost: MyCommentActivityPostReference
}

struct MyCommentActivityPostReference: Identifiable {
    let id: Int
    let type: VoteType       // 참조 게시글 타입 아이콘 표시용
    let title: String
    let thumbnailUrl: URL?
}
