//
//  CustomTabBar.swift
//  Pickple
//
//  Created by 박윤수 on 9/16/26.
//
//  네이티브 TabView의 탭바는 스크롤에 따라 숨겼다 보였다 하는 애니메이션(슬라이드 vs
//  페이드)을 우리가 고를 수 없어서, 직접 그린 하단 바로 대체했다. PickpleBottomNav가
//  TabBarVisibilityController.isHidden 값에 따라 이 바를 offset(y:)로 화면 밖까지
//  밀어내려 진짜로 위아래로 움직이는 슬라이드를 만든다.
//
//  기준은 iOS 26의 Liquid Glass 탭바 룩 — 화면 가장자리에서 띄운 캡슐(알약) 모양에
//  glassEffect()로 진짜 시스템 유리 소재를 쓴다. 26 미만(우리 배포 타겟은 18.0)에서는
//  이 API 자체가 없어서, 예전 스타일(화면 폭 꽉 채운 바 + 얇은 구분선 + 시스템 바
//  블러 소재)로 폴백한다.
import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int

    static let height: CGFloat = 56

    private let items: [(title: String, icon: String, tag: Int)] = [
        (MainStrings.tabHome, "PickpleHome", 0),
        (MainStrings.tabCommunity, "PickpleMessage", 1),
        (MainStrings.tabMyPage, "PickpleUser", 2)
    ]

    var body: some View {
        if #available(iOS 26.0, *) {
            tabItemsRow
                .frame(height: Self.height)
                .glassEffect(.regular, in: Capsule())
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
        } else {
            tabItemsRow
                .frame(height: Self.height)
                .background(alignment: .top) {
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.navy10)
                            .frame(height: 0.5)
                        Rectangle()
                            .fill(.clear)
                    }
                    .background(.bar)
                    .ignoresSafeArea(edges: .bottom)
                }
        }
    }

    private var tabItemsRow: some View {
        HStack(spacing: 0) {
            ForEach(items, id: \.tag) { item in
                Button(action: { selectedTab = item.tag }) {
                    VStack(spacing: 2) {
                        Image(item.icon)
                            .renderingMode(selectedTab == item.tag ? .template : .original)
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text(item.title)
                            .pickpleTypography(.caption)
                    }
                    .foregroundStyle(selectedTab == item.tag ? Color.navy60 : Color.neutral40)
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(0))
    }
}
