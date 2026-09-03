//
//  ABStepTwoView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

// A/B 픽 2단계: 상품A 정보 입력(사진 1장 필수, 상품명, 가격, URL).
struct ABStepTwoView: View {
    @ObservedObject var postViewModel: PostViewModel

    var body: some View {
        ProductInfoFieldBlock(
            stepTitle: PostViewStrings.productATitle,
            product: $postViewModel.productA,
            maxPhotoCount: 3,
            photoHint: PostViewStrings.photoHintExactlyOne,
            productNameMaxLength: postViewModel.productNameMaxLength
        )
    }
}
