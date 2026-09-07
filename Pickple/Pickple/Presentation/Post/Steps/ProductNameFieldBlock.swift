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
        }
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
