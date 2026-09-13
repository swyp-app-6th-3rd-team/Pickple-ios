//
//  PickpleTabBar.swift
//  Pickple
//
//  Created by 박윤수 on 8/28/26.
//
// 1차 점검 완료 - 9월 13일

import SwiftUI

struct PickpleTabBar: View {
    let tabs: [String]
    @Binding var selectedIndex: Int
    
    var color: Color = .yellow60

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs.indices, id: \.self) { index in
                Button {
                    selectedIndex = index
                } label: {
                    VStack(spacing: 8) {
                        Text(tabs[index])
                            .pickpleTypography(.title02)
                            .foregroundStyle(index == selectedIndex ? .black : .neutral20)

                        Rectangle()
                            .fill(index == selectedIndex ? color : Color.clear)
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
