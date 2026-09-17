//
//  VoteType.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//
//  찬반 픽 / 비교 픽 / 일반 글. Main, Community, MyPage, Post 전반에서
//  공용으로 쓰이는 도메인 개념이라 Post 작성 화면 전용 파일에서 분리했다.

import Foundation

// Hashable: CardStackViewModel이 타입별(찬반/AB) 카드 버퍼를 딕셔너리 키로 관리한다.
enum VoteType: Equatable, Hashable, Identifiable {
    case forAgainst
    case ab
    case text

    // 서버 게시글 type 값(GENERAL/AGREE/A_B)을 앱 도메인 값으로 매핑.
    init(serverType: String) {
        switch serverType {
        case "AGREE": self = .forAgainst
        case "A_B": self = .ab
        default: self = .text
        }
    }

    // .sheet(item:)/.fullScreenCover(item:) 등 Identifiable이 필요한 곳에서 값 자체를 식별자로 쓴다.
    var id: Self { self }

    // 게시글 작성(POST /posts) 요청에 보낼 서버 type 값. init(serverType:)의 역방향.
    var serverTypeValue: String {
        switch self {
        case .forAgainst: return "AGREE"
        case .ab: return "A_B"
        case .text: return "GENERAL"
        }
    }
}
