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
        // GeometryReader를 .frame(height: 0)로 직접 두면 부모가 0 크기로 배치해버려서
        // PreferenceKey가 아예 안 불리는 경우가 있다(알려진 SwiftUI 이슈) — 대신 실제 높이가
        // 있는 뷰의 .background로 붙여서 유효한 레이아웃 크기를 갖게 한다.
        Color.clear
            .frame(height: 1)
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self, value: proxy.frame(in: .named(coordinateSpaceName)).minY)
                }
            }
    }
}
