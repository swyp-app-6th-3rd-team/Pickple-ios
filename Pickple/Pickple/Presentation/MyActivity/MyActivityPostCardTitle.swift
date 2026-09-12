//
//  MyActivityPostCardTitle.swift
//  Pickple
//
//  Created by 박윤수 on 9/11/26.
//

import SwiftUI

struct MyActivityPostCardTitle: View {
    var title: String
    var decription: String
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .lineLimit(1)
                .pickpleTypography(.body01)
                .foregroundStyle(Color.black)
            
            //설명 공백 대비
            Text(decription.isEmpty ? " " : decription)
                .lineLimit(1)
                .pickpleTypography(.body02)
                .foregroundStyle(Color.neutral40)
        }
    }
}

#Preview {
    MyActivityPostCardTitle(title: "나이키 에어포스를 흰색으로 살까?", decription: "데일리로 신을건데 나이키 흰색 어때?")
}
