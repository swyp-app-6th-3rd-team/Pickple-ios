//
//  ProductPriceFieldBlock.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
// 1차 점검 완료 - 9월 12일
//
//  상품 정보 입력에서 공통으로 쓰는 숫자 입력창(선택 입력). 라벨은 안 그린다 — 호출부(섹션)가
//  공용 헤더로 붙인다.

import SwiftUI

struct ProductPriceFieldBlock: View {
    // price는 숫자 문자열 그대로 유지한다 — PostViewModel이 Int(price)로 파싱해 서버로
    // 보낸다. 쉼표는 화면에 보여줄 때만 붙이고, 실제 바인딩 값은 건드리지 않는다.
    @Binding var price: String
    var isDisabled: Bool = false
    var AB: String = ""

    @FocusState private var isFocused: Bool
    @State private var displayText: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            PickpleTextField(
                text: $displayText,
                type: .trailing,
                placeholder: "\(AB) 가격을 입력해 주세요",
                trailingAccessory: .text(PostViewStrings.priceUnit),
                state: isFocused ? .ing : ._default
            )
            .focused($isFocused)
            .keyboardType(.numberPad)
            .onChange(of: displayText) { _, newValue in
                let digitsOnly = newValue.filter(\.isNumber)
                let capped = min(Int(digitsOnly) ?? 0, 999_999_999)
                price = digitsOnly.isEmpty ? "" : String(capped)

                let formatted = Self.commaFormatted(price)
                if displayText != formatted {
                    displayText = formatted
                }
            }
            .onAppear {
                displayText = Self.commaFormatted(price)
            }
            .disabled(isDisabled)
        }
    }

    private static func commaFormatted(_ digits: String) -> String {
        guard let value = Int(digits) else { return "" }
        return value.formatted()
    }
}

#Preview {
    VStack(spacing: 20) {
        ProductPriceFieldBlock(price: .constant(""), AB: "A")
        ProductPriceFieldBlock(price: .constant("120000"), AB: "A")
    }
    .padding()
}
