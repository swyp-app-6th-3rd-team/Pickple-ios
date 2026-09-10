//
//  ProductURLFieldBlock.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  상품 정보 입력에서 공통으로 쓰는 "URL" 라벨 + 입력창(선택 입력).

import SwiftUI

struct ProductURLFieldBlock: View {
    @Binding var url: String
    var label: String = PostViewStrings.url
    var isDisabled: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .pickpleTypography(.body01)

            PickpleTextField(
                text: $url,
                type: .leading,
                placeholder: PostViewStrings.urlPlaceholder
            )
            .disabled(isDisabled)
        }
        .opacity(isDisabled ? 0.5 : 1)
    }
}

#Preview {
    VStack(spacing: 20) {
        ProductURLFieldBlock(url: .constant(""))
        ProductURLFieldBlock(url: .constant("https://example.com/product"))
        ProductURLFieldBlock(url: .constant(""), label: "A URL")
    }
    .padding()
}
