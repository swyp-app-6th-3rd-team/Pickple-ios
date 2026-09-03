//
//  ABStepThreeView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

// A/B 픽 3단계: 상품B 정보 입력(사진 1장 필수, 상품명, 가격, URL).
struct ABStepThreeView: View {
    @ObservedObject var postViewModel: PostViewModel

    var body: some View {
        ProductInfoFieldBlock(
            stepTitle: PostViewStrings.productBTitle,
            product: $postViewModel.productB,
            maxPhotoCount: 3,
            photoHint: PostViewStrings.photoHintExactlyOne,
            productNameMaxLength: postViewModel.productNameMaxLength
        )
    }
}
