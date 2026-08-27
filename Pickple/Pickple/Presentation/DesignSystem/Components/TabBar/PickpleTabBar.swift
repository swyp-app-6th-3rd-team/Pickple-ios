//
//  PickpleTabBar.swift
//  Pickple
//
//  Created by 박윤수 on 8/28/26.
//
//  TODO: 디자인 확정 후 변경 필요
//  - 색상: Color.black/gray → Asset Catalog 컬러셋으로 교체
//  - 폰트: "Nunito-ExtraBold" 하드코딩 → 폰트명/크기 확정 후 상수로 교체
//

import SwiftUI

struct PickpleTabBar: View {
    let tabs: [String]
    @Binding var selectedIndex: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs.indices, id: \.self) { index in
                Button {
                    selectedIndex = index
                } label: {
                    VStack(spacing: 8) {
                        Text(tabs[index])
                            .font(.custom("Nunito-ExtraBold", size: 16)) //실제 폰트로 변경
                            .foregroundStyle(index == selectedIndex ? Color.black : Color.gray)

                        Rectangle()
                            .fill(index == selectedIndex ? Color.black : Color.clear)
                            .frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedIndexTwo = 0
    @Previewable @State var selectedIndexThree = 1

    VStack(spacing: 40) {
        // 탭 2개 (찬반 픽 / 비교 픽)
        PickpleTabBar(tabs: ["찬반 픽", "비교 픽"], selectedIndex: $selectedIndexTwo)

        // 탭 3개
        PickpleTabBar(tabs: ["A", "B", "C"], selectedIndex: $selectedIndexThree)
    }
    .padding()
}
