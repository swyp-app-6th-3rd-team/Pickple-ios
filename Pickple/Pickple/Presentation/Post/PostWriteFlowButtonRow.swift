//
//  PostWriteFlowButtonRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//
//  하단 게시 버튼. 예전엔 이전/다음 버튼이 있었지만, 작성 화면이 한 화면으로
//  합쳐지면서 더 이상 단계를 오갈 필요가 없어 게시 버튼 하나만 남았다.

import SwiftUI

struct PostWriteFlowButtonRow: View {
    let title: String
    let isEnabled: Bool
    let onSubmit: () -> Void

    var body: some View {
        Button(action: onSubmit) {
            Text(title)
        }
        .buttonStyle(.pickple(isEnabled ? .enabled : .disabled, 52))
        .disabled(!isEnabled)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}
