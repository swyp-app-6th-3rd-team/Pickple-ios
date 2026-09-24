//
//  TabBarHideOnScroll.swift
//  Pickple
//
//  Created by 박윤수 on 9/24/26.
//
//  onScrollGeometryChange의 action은 "매 프레임" 갱신값이라, 마지막으로 실제 토글한
//  offset을 앵커로 들고 있다가 거기서부터 threshold 이상 누적으로 움직였을 때만
//  반응하도록 한다 — 안 그러면 LazyVStack 셀 높이 보정 같은 작은 튐도 방향 반전으로
//  잡힌다.

import SwiftUI

private struct TabBarHideOnScrollModifier: ViewModifier {
    let isScrolledDown: Binding<Bool>
    let threshold: CGFloat
    @State private var lastToggleOffset: CGFloat = 0

    func body(content: Content) -> some View {
        content.onScrollGeometryChange(for: CGFloat.self) { geometry in
            geometry.contentOffset.y
        } action: { _, newOffset in
            // 최상단 근처(당겨서 새로고침 포함)에서는 항상 탭바를 보여준다.
            guard newOffset > 0 else {
                lastToggleOffset = newOffset
                withAnimation(.easeInOut(duration: 0.2)) {
                    isScrolledDown.wrappedValue = false
                }
                return
            }

            let delta = newOffset - lastToggleOffset
            guard abs(delta) > threshold else { return }

            lastToggleOffset = newOffset
            withAnimation(.easeInOut(duration: 0.2)) {
                isScrolledDown.wrappedValue = delta > 0
            }
        }
    }
}

extension View {
    // 하단 탭바 숨김/노출 전용 — ScrollView의 콘텐츠 쪽에 붙인다.
    func onTabBarHideScroll(isScrolledDown: Binding<Bool>, threshold: CGFloat = 40) -> some View {
        modifier(TabBarHideOnScrollModifier(isScrolledDown: isScrolledDown, threshold: threshold))
    }
}
