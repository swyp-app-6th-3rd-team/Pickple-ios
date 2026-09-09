//
//  MyPagePostTitleView.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//

import SwiftUI

struct MyPagePostTitleView: View {
    var isLoggedIn: Bool = true
    var onTapMore: () -> Void = {}

    var body: some View {
        //XMARK: - Title
        HStack {
            Text(MyPageStrings.myPostsTitle)
                .pickpleTypography(.title01)
                .foregroundStyle(Color.black)

            Spacer()

            Button(action: onTapMore) {
                HStack(spacing: 4) {
                    Text(MyPageStrings.viewAll)

                    Image("PickpleArrowRight")
                        .resizable()
                        .frame(width: 16, height: 16)
                }

            }
            // 게스트는 명세대로 [전체보기] 클릭을 제한한다.
            .disabled(!isLoggedIn)
            .pickpleTypography(.body02)
            .foregroundStyle(Color.neutral40)
        }
    }
}

#Preview {
    MyPagePostTitleView()
}
