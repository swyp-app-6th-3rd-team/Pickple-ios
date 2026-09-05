//
//  PostDetailStrings.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import Foundation

enum PostDetailStrings {
    static let navTitle = "게시글 상세"

    static let commentEmptyMessage = "아직 작성된 댓글이 없어요"
    static let commentPlaceholder = "댓글 입력..."
    static let commentSubmit = "등록"

    static func pickCount(_ count: Int) -> String { "원픽 \(count)" }
    static func commentCount(_ count: Int) -> String { "댓글 \(count)" }

    static let menuEdit = "수정하기"
    static let menuDelete = "삭제하기"
    static let menuReport = "신고하기"
    static let menuBlock = "차단하기"
    static let menuClose = "닫기"

    static let voteRequiredTitle = "로그인이 필요해요"
    static let voteRequiredDescription = "간편 로그인 후 더 많은 투표에\n참여해 보세요"
    static let commentRequiredDescription = "간편 로그인 후 댓글을\n작성할 수 있어요"
    static let cancel = "취소"
    static let login = "로그인"

    static let pickConfirmTitle = "해당 답변자를 픽할까요?"
    static let pickConfirmDescription = "한 번 픽하면 취소할 수 없어요"
    static let pickConfirmButton = "픽하기"

    static let productNameLabel = "상품명"
    static let priceLabel = "가격"
    static let purchaseLinkLabel = "구매처"

    static let productAFallback = "상품A"
    static let productBFallback = "상품B"
    static let voteSideFor = "사자"
    static let voteSideAgainst = "말자"
}
