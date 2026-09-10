//
//  ProductPriceFieldBlock.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  상품 정보 입력에서 공통으로 쓰는 "가격" 라벨 + 숫자 입력창(선택 입력).

import SwiftUI

struct ProductPriceFieldBlock: View {
    @Binding var price: String
    var label: String = PostViewStrings.price
    var isDisabled: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .pickpleTypography(.body01)
            //4c4c4c 색상 미정

            PickpleTextField(
                text: $price,
                type: .trailing,
                placeholder: "0",
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
        .opacity(isDisabled ? 0.5 : 1)
    }
}

#Preview {
    VStack(spacing: 20) {
        ProductPriceFieldBlock(price: .constant(""))
        ProductPriceFieldBlock(price: .constant("120000"))
        ProductPriceFieldBlock(price: .constant(""), label: "A 가격")
    }
    .padding()
}
