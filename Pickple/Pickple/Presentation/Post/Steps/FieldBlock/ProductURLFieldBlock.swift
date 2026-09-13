//
//  ProductURLFieldBlock.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
// 1차 점검 완료 - 9월 12일
//
//  상품 정보 입력에서 공통으로 쓰는 URL 입력창(선택 입력). 라벨은 안 그린다 — 호출부(섹션)가
//  공용 헤더로 붙인다.

import SwiftUI

struct ProductURLFieldBlock: View {
    @Binding var url: String
    var isDisabled: Bool = false
    var AB: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            PickpleTextField(
                text: $url,
                type: .leading,
                placeholder: "\(AB) " + PostViewStrings.urlPlaceholder
            )
            .disabled(isDisabled)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ProductURLFieldBlock(url: .constant(""))
        ProductURLFieldBlock(url: .constant("https://example.com/product"))
    }
    .padding()
}
