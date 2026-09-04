//
//  VoteCard.swift
//  Pickple
//
//  Created by 박윤수 on 8/31/26.
//
import Foundation

struct VoteCard: Identifiable {
    let id: UUID
    let type: VoteType          // 찬반 픽 / 비교 픽 (기존 enum 재사용)
    let productName: String     // 제품명, 30자 제한 (AB는 주제로 사용)
    let concernText: String     // 고민 한마디, 100자 제한
    let imageName: String       // 찬반: 대표 사진 1장. AB: 상품A 사진
    let secondImageName: String? // AB 전용 상품B 사진. 찬반은 nil
    let participantCount: Int
    // 투표 전엔 nil로 블라인드 처리(투표 UI), 투표 후엔 값이 채워지며 결과 게이지로 전환.
    var firstPercentage: Int?
    var secondPercentage: Int?

    var isVoted: Bool { firstPercentage != nil }

    //추후 API 스펙에 맞게 수정
}
