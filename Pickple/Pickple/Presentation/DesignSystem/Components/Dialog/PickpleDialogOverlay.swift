//
//  PickpleDialogOverlay.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//
// 1차 점검 완료 - 9월 13일

import SwiftUI

struct PickpleDialogOverlay<Content: View>: View {
    var onTapDismiss: (() -> Void)? = nil
    @ViewBuilder let content: Content

    var body: some View {
        Color.black.opacity(0.6)
            .ignoresSafeArea()
            .onTapGesture { onTapDismiss?() }
        content
            .padding(.horizontal, 40)
    }
}
