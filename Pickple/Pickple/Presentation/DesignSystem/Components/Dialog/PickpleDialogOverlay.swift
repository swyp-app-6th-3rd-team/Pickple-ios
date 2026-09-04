//
//  PickpleDialogOverlay.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//
//  화면 전체를 덮는 반투명 배경 위에 중앙 모달(주로 PickpleConfirmDialog류)을 띄운다.
//  기존에 여러 화면이 각자 Color.black.opacity(0.4).ignoresSafeArea()를 반복 작성하던 걸 모았다.

import SwiftUI

struct PickpleDialogOverlay<Content: View>: View {
    var onTapDismiss: (() -> Void)? = nil
    @ViewBuilder let content: Content

    var body: some View {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
            .onTapGesture { onTapDismiss?() }
        content
            .padding(.horizontal, 40)
    }
}
