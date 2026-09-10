//
//  ProductNameFieldBlock.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  상품 정보 입력에서 공통으로 쓰는 "상품명" 라벨 + 입력창 + 글자 수 카운터.

import SwiftUI

struct ProductNameFieldBlock: View {
    @Binding var name: String
    let maxLength: Int
    var label: String = PostViewStrings.productName
    // 게시글 수정 모드에서는 상품명이 API로 반영되지 않아(PATCH는 category/title/description만
    // 받음) 원래 값을 보여주기만 하고 편집은 막는다 — 디자인 확정 전까지는 투명도로만 표시.
    var isDisabled: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            (Text(label) + Text(" ") + Text(PostViewStrings.requiredMark).foregroundStyle(Color.red60))
                .pickpleTypography(.body01)

            PickpleTextField(
                text: $name,
                type: .trailing,
                placeholder: PostViewStrings.productNamePlaceholder,
                trailingAccessory: .text("\(name.count)/\(maxLength)")
            )
            .onChange(of: name) { _, newValue in
                if newValue.count > maxLength {
                    name = String(newValue.prefix(maxLength))
                }
            }
            .disabled(isDisabled)
        }
        .opacity(isDisabled ? 0.5 : 1)
    }
}

#Preview {
    VStack(spacing: 20) {
        ProductNameFieldBlock(name: .constant(""), maxLength: 30)
        ProductNameFieldBlock(name: .constant("에어포스 흰색"), maxLength: 30)
        ProductNameFieldBlock(name: .constant(""), maxLength: 30, label: "A 상품명")
    }
    .padding()
}
