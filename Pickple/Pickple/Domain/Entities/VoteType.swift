//
//  VoteType.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//
//  찬반 픽 / 비교 픽 / 일반 글. Main, Community, MyPage, Post 전반에서
//  공용으로 쓰이는 도메인 개념이라 Post 작성 화면 전용 파일에서 분리했다.

import Foundation

enum VoteType: Equatable {
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
}
