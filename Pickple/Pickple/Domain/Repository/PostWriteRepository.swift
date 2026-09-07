//
//  PostWriteRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  게시글 작성(POST /posts) 전용. 조회는 CommunityRepository/UserPostRepository가 맡고,
//  이건 새 글을 쓰는 쪽만 담당한다. 수정(PATCH)/삭제(DELETE)는 스펙에 없어서 여기 없음 —
//  PostDetailView의 "수정하기"는 여전히 Mock(PostViewModel 기본 repository)만 써야 한다.

import UIKit

struct PostWriteProductDraft {
    let photos: [UIImage]
    let name: String
    let price: Int?
    let linkUrl: String?
}

protocol PostWriteRepository {
    // category는 화면에 쓰는 한글 라벨(예: "패션/잡화") 그대로 받는다. 서버 enum 값(FASHION 등)으로
    // 바꾸는 건 Remote 구현체 책임 — RemoteUserPostRepository의 반대 방향 매핑과 대칭이다.
    func createPost(
        type: VoteType,
        category: String,
        title: String?,
        description: String?,
        products: [PostWriteProductDraft]
    ) async throws -> Int
}
