//
//  ForAgainstStepTwoView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

// 찬반 픽 2단계: 상품 정보 입력(사진 1~3장, 상품명, 가격, URL).
struct ForAgainstStepTwoView: View {
    @ObservedObject var postViewModel: PostViewModel

    var body: some View {
        ProductInfoFieldBlock(
            stepTitle: PostViewStrings.productInfoTitle,
            product: $postViewModel.product,
            maxPhotoCount: 3,
            photoHint: PostViewStrings.photoHintUpToThree,
            productNameMaxLength: postViewModel.productNameMaxLength
        )
    }
}
