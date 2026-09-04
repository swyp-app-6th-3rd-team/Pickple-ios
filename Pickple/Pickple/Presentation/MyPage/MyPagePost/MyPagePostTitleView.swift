//
//  MyPagePostTitleView.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//

import SwiftUI

struct MyPagePostTitleView: View {
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
            .pickpleTypography(.body02)
            .foregroundStyle(Color.neutral40)
        }
    }
}

#Preview {
    MyPagePostTitleView()
}
