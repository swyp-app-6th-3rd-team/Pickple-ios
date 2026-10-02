//
//  MyActivityEmptyView.swift
//  Pickple
//
//  Created by 박윤수 on 10/2/26.
//
//  나의 활동 세 탭이 공통으로 쓰는 빈 상태.

import SwiftUI

struct MyActivityEmptyView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text(MyActivityStrings.emptyMessage)
                .pickpleTypography(.body02_500)
            Spacer()
        }
    }
}

#Preview {
    MyActivityEmptyView()
}
