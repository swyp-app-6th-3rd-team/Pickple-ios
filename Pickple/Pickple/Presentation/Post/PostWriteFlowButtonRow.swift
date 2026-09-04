//
//  PostWriteFlowButtonRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//
//  하단 이전/다음(또는 게시) 버튼 줄.

import SwiftUI

struct PostWriteFlowButtonRow: View {
    let showsPrevious: Bool
    let primaryTitle: String
    let isPrimaryEnabled: Bool
    let onPrevious: () -> Void
    let onPrimary: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            if showsPrevious {
                Button(action: onPrevious) {
                    Text(PostViewStrings.previous)
                }
                .buttonStyle(.pickple(._default, 52))
            }

            Button(action: onPrimary) {
                Text(primaryTitle)
            }
            .buttonStyle(.pickple(isPrimaryEnabled ? .enabled : .disabled, 52))
            .disabled(!isPrimaryEnabled)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}
