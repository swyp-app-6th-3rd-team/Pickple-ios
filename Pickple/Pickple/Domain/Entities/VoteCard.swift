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
    let productName: String     // 제품명, 30자 제한
    let concernText: String     // 고민 한마디, 100자 제한
    let imageName: String       // Mock 단계에선 로컬 에셋/SF Symbol
    
    //추후 API 스펙에 맞게 수정
}
