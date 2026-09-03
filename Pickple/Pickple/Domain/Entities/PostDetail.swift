//
//  PostDetail.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Foundation

struct PostDetailProduct {
    let name: String
    let price: Int
    let purchaseURL: String

    // 구매처 문자열에 스킴이 없으면 https를 붙여서 실제로 열 수 있는 URL로 만든다.
    var purchaseLink: URL? {
        if purchaseURL.hasPrefix("http://") || purchaseURL.hasPrefix("https://") {
            return URL(string: purchaseURL)
        }
        return URL(string: "https://\(purchaseURL)")
    }
}

enum PostDetailVoteSide: Equatable {
    case first
    case second
}

struct PostDetail: Identifiable {
    let id: UUID
    let type: VoteType
    let category: String
    let title: String
    let description: String
    let images: [String]
    let authorNickname: String
    let authorLevel: Int
    let authorProfileImageName: String?
    let isMine: Bool
    let createdAt: Date
    let participantCount: Int
    // 찬반: firstProduct만 사용. A/B: firstProduct=상품A, secondProduct=상품B. 일반: 둘 다 nil.
    let firstProduct: PostDetailProduct?
    let secondProduct: PostDetailProduct?
}
