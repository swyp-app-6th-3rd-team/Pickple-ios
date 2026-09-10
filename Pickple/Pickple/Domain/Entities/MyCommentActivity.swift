//
//  MyCommentActivity.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  '나의 활동 > 댓글' 탭 전용. Comment(단일 게시글 스레드 안의 댓글)와 달리
//  여러 게시글에 걸친 내 댓글 목록이라 참조 게시글 정보를 함께 들고 있어야 한다.
//  내가 댓글 단 게시글 목록(GET /users/me/activities?type=COMMENT) + 게시글별 댓글 목록
//  (GET /posts/{id}/comments, mine==true 필터)을 조합해서 채운다 — RemoteUserPostRepository 참고.

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
