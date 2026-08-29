//
//  PickpleProgressBar.swift
//  Pickple
//
//  Created by 박윤수 on 8/28/26.
//
//  TODO: 디자인 확정 후 변경 필요
//  - 색상: Color.black/gray → Asset Catalog 컬러셋으로 교체
//

import SwiftUI

struct PickpleProgressBar: View {
    let totalSteps: Int
    let currentIndex: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Rectangle()
                    .fill(index <= currentIndex ? Color.black : Color.neutral5)
                    .frame(height: 4)
            }
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        // 2단계 중 1단계까지 진행
        PickpleProgressBar(totalSteps: 2, currentIndex: 0)

        // 3단계 중 2단계까지 진행
        PickpleProgressBar(totalSteps: 3, currentIndex: 1)
    }
    .padding()
}
