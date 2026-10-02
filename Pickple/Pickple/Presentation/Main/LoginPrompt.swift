//
//  LoginPrompt.swift
//  Pickple
//
//  Created by 박윤수 on 10/2/26.
//
//  탭 루트 화면(홈·랭킹·커뮤니티·마이페이지)의 "로그인이 필요해요" 다이얼로그.
//  화면 안에 그리면 하단 탭바(TabView가 화면 바깥에 그림)가 딤에 안 덮이고 눌리므로,
//  화면은 showLoginPrompt로 종류만 알리고 PickpleTabView가 TabView 위(overlay)에 그린다.
//  fullScreenCover로 띄운 화면(글쓰기 등)은 TabView보다 위층이라 여기서 그리면 가려진다 —
//  그런 화면에서는 쓰지 않는다.

import SwiftUI

// 문구는 화면별 Strings를 그대로 쓴다(공용으로 합치지 않음).
enum LoginPrompt {
    case main
    case community
    case myPosts
    case myPageInfo

    var title: String {
        switch self {
        case .main: return MainStrings.loginRequiredTitle
        case .community: return CommunityStrings.loginRequiredTitle
        case .myPosts: return MyPageStrings.myPostsLoginRequiredTitle
        case .myPageInfo: return MyPageStrings.infoLoginRequiredTitle
        }
    }

    var description: String {
        switch self {
        case .main: return MainStrings.loginRequiredDescription
        case .community: return CommunityStrings.loginRequiredDescription
        case .myPosts: return MyPageStrings.myPostsLoginRequiredDescription
        case .myPageInfo: return MyPageStrings.infoLoginRequiredDescription
        }
    }

    var cancelTitle: String {
        switch self {
        case .community: return CommunityStrings.cancel
        case .main, .myPosts, .myPageInfo: return MainStrings.cancel
        }
    }

    var confirmTitle: String {
        switch self {
        case .community: return CommunityStrings.login
        case .main, .myPosts, .myPageInfo: return MainStrings.login
        }
    }
}

private struct ShowLoginPromptKey: EnvironmentKey {
    static let defaultValue: (LoginPrompt) -> Void = { _ in }
}

extension EnvironmentValues {
    var showLoginPrompt: (LoginPrompt) -> Void {
        get { self[ShowLoginPromptKey.self] }
        set { self[ShowLoginPromptKey.self] = newValue }
    }
}
