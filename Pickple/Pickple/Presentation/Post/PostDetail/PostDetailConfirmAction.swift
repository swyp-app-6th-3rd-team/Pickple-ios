//
//  PostDetailConfirmAction.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//
//  게시글 더보기 메뉴에서 트리거되는 확인 모달 3종(삭제/신고/차단).

import Foundation

enum PostDetailConfirmAction {
    case delete
    case report
    case block

    var title: String {
        switch self {
        case .delete: "게시글을 삭제할까요?"
        case .report: "게시글을 신고할까요?"
        case .block: "게시자를 차단할까요?"
        }
    }

    var description: String {
        switch self {
        case .delete: "게시글을 삭제하면 다시는\n볼 수 없어요"
        case .report: "이유없이 신고 시 활동이\n제한될 수 있어요"
        case .block: "차단하면 이 게시자의 모든 게시물을\n다시는 볼 수 없어요"
        }
    }

    var confirmTitle: String {
        switch self {
        case .delete: "삭제"
        case .report: "신고"
        case .block: "차단"
        }
    }
}
