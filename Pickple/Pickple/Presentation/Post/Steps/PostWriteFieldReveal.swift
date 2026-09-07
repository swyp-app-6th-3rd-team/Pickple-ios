//
//  PostWriteFieldReveal.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  게시글 작성 단계에서 여러 입력 필드를 한 번에 다 보여주지 않고, 이전(필수) 필드를
//  채워야 다음 필드가 나타나게 하기 위한 공용 트랜지션. 모든 단계(찬반/비교/일반,
//  상품 정보 블록)에서 동일하게 쓴다.

import SwiftUI

extension View {
    @ViewBuilder
    func revealed(_ isVisible: Bool) -> some View {
        if isVisible {
            self.transition(.opacity.combined(with: .move(edge: .top)))
        }
    }
}
