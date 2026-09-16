//
//  ScrollOffsetAnchor.swift
//  Pickple
//
//  Created by 박윤수 on 9/16/26.
//
//  ScrollView 맨 위에 심어두면, 그 ScrollView의 coordinateSpace 기준으로 최상단에서
//  얼마나 스크롤됐는지(y좌표)를 상위 뷰가 onPreferenceChange로 관찰할 수 있게 해준다.
//  탭바를 스크롤 다운 시 숨기는 것처럼, 화면마다 반복되는 "스크롤 위치 기반 UI 토글"에 공용으로 쓴다.

import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ScrollOffsetAnchor: View {
    let coordinateSpaceName: String

    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(key: ScrollOffsetPreferenceKey.self, value: proxy.frame(in: .named(coordinateSpaceName)).minY)
        }
        .frame(height: 0)
    }
}
