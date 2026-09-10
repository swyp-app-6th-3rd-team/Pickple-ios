//
//  PostWriteRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  게시글 작성(POST /posts)·수정(PATCH /posts/{id}) 전용. 조회는 CommunityRepository/
//  UserPostRepository가 맡고, 이건 쓰기 쪽만 담당한다. 삭제(DELETE)는 PostDetailRepository에 있음.
//  PATCH는 category/title/description만 받고 상품 정보(사진/이름/가격/URL)와 유형은 바꿀 수
//  없다(API_SPEC 기준) — 수정 화면은 그 필드들을 원래 값으로 보여주되 비활성화해야 한다.

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

    // title이 nil이면 서버가 기존 값을 유지한다(찬반은 title=상품명이라 항상 nil로 보내 유지시킴).
    // description은 옵셔널이 아니다 — 빈 문자열을 보내면 "지운다"는 뜻이라, 생성 때(nil=선택
    // 입력 안 함)와 의미가 다르다.
    func updatePost(id: Int, category: String, title: String?, description: String) async throws
}
