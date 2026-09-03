//
//  ProductInfoFieldBlock.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

// 상품 정보 단계(찬반 2단계 / 비교 2·3단계)에서 공통으로 쓰는
// 사진 + 상품명 + 가격 + URL 입력 묶음.
struct ProductInfoFieldBlock: View {
    let stepTitle: String
    @Binding var product: PostProductDraft
    let maxPhotoCount: Int
    let photoHint: String
    let productNameMaxLength: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(stepTitle)
                .pickpleTypography(.heading02)
                .foregroundStyle(Color.neutral100)

            PhotoUploadFieldBlock(photos: $product.photos, maxCount: maxPhotoCount, hintText: photoHint)

            VStack(alignment: .leading, spacing: 8) {
                (Text(PostViewStrings.productName) + Text(" ") + Text(PostViewStrings.requiredMark).foregroundStyle(Color.red60))
                    .pickpleTypography(.body01)

                PickpleTextField(
                    text: $product.name,
                    type: .trailing,
                    placeholder: PostViewStrings.productNamePlaceholder,
                    trailingAccessory: .text("\(product.name.count)/\(productNameMaxLength)")
                )
                .onChange(of: product.name) { _, newValue in
                    if newValue.count > productNameMaxLength {
                        product.name = String(newValue.prefix(productNameMaxLength))
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(PostViewStrings.price)
                    .pickpleTypography(.body01)

                PickpleTextField(
                    text: $product.price,
                    type: .trailing,
                    placeholder: "0",
                    trailingAccessory: .text(PostViewStrings.priceUnit)
                )
                .keyboardType(.numberPad)
                .onChange(of: product.price) { _, newValue in
                    let digitsOnly = newValue.filter(\.isNumber)
                    let capped = min(Int(digitsOnly) ?? 0, 999_999_999)
                    product.price = digitsOnly.isEmpty ? "" : String(capped)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(PostViewStrings.url)
                    .pickpleTypography(.body01)

                PickpleTextField(
                    text: $product.url,
                    type: .leading,
                    placeholder: PostViewStrings.urlPlaceholder
                )
            }
        }
        .padding(20)
    }
}

#Preview {
    ProductInfoFieldBlock(
        stepTitle: PostViewStrings.productInfoTitle,
        product: .constant(PostProductDraft()),
        maxPhotoCount: 3,
        photoHint: PostViewStrings.photoHintUpToThree,
        productNameMaxLength: 30
    )
}
