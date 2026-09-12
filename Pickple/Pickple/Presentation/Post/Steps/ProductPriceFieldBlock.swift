//
//  ProductPriceFieldBlock.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  상품 정보 입력에서 공통으로 쓰는 숫자 입력창(선택 입력). 라벨은 안 그린다 — 호출부(섹션)가
//  공용 헤더로 붙인다.

import SwiftUI

struct ProductPriceFieldBlock: View {
    @Binding var price: String
    var isDisabled: Bool = false
    var AB: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            PickpleTextField(
                text: $price,
                type: .trailing,
                placeholder: "\(AB) 가격을 입력해 주세요",
                trailingAccessory: .text(PostViewStrings.priceUnit)
            )
            .keyboardType(.numberPad)
            .onChange(of: price) { _, newValue in
                let digitsOnly = newValue.filter(\.isNumber)
                let capped = min(Int(digitsOnly) ?? 0, 999_999_999)
                price = digitsOnly.isEmpty ? "" : String(capped)
            }
            .disabled(isDisabled)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ProductPriceFieldBlock(price: .constant(""), AB: "A")
        ProductPriceFieldBlock(price: .constant("120000"), AB: "A")
    }
    .padding()
}
