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

    private var isPhotoFilled: Bool { !product.photos.isEmpty }
    private var isNameFilled: Bool { !product.name.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(stepTitle)
                .pickpleTypography(.heading02)
                .foregroundStyle(Color.neutral100)

            PhotoUploadSectionView(photos: $product.photos, maxCount: maxPhotoCount, hintText: photoHint)

            ProductNameFieldBlock(name: $product.name, maxLength: productNameMaxLength)
                .revealed(isPhotoFilled)

            ProductPriceFieldBlock(price: $product.price)
                .revealed(isPhotoFilled && isNameFilled)

            ProductURLFieldBlock(url: $product.url)
                .revealed(isPhotoFilled && isNameFilled)
        }
        .padding(20)
        .animation(.easeInOut, value: isPhotoFilled)
        .animation(.easeInOut, value: isNameFilled)
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
