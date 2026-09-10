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

// 한 번 나타난 필드는 이전 필드를 다시 지워도 사라지지 않아야 한다(명세: 단계가 한 번
// 열리면 유지). isVisible을 그대로 조건으로 쓰면 이전 필드를 지웠을 때 isVisible이
// 다시 false가 되면서 필드가 사라지므로, "한 번이라도 true였는지"를 별도로 기억한다.
private struct FieldRevealModifier: ViewModifier {
    let isVisible: Bool
    @State private var hasBeenRevealed = false

    func body(content: Content) -> some View {
        Group {
            if hasBeenRevealed {
                content.transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .onAppear {
            if isVisible { hasBeenRevealed = true }
        }
        .onChange(of: isVisible) { _, newValue in
            if newValue { hasBeenRevealed = true }
        }
    }
}

extension View {
    func revealed(_ isVisible: Bool) -> some View {
        modifier(FieldRevealModifier(isVisible: isVisible))
    }
}
