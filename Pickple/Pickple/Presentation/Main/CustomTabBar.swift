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
//  기준은 iOS 26의 Liquid Glass 탭바 룩 — 화면 가장자리에서 띄운 캡슐(바깥) 안에,
//  현재 선택된 탭을 가리키는 작은 캡슐(안쪽)이 얹혀 있는 이중 구조다. 크기를
//  302x62/102x54 같은 고정값으로 박지 않고, 콘텐츠(아이콘+라벨) 크기에 패딩을 얹어서
//  자연스럽게 정해지게 한다 — 라벨 길이가 다 다르고(홈/커뮤니티/마이) Dynamic Type도
//  있어서 고정값은 쉽게 깨진다. 26 미만(우리 배포 타겟은 18.0)에서는 glassEffect
//  자체가 없어서, 예전 스타일(화면 폭 꽉 채운 바 + 얇은 구분선 + 시스템 바 블러
//  소재)로 폴백한다.
import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Namespace private var glassNamespace

    static let height: CGFloat = 56

    private let items: [(title: String, icon: String, tag: Int)] = [
        (MainStrings.tabHome, "PickpleHome", 0),
        (MainStrings.tabCommunity, "PickpleMessage", 1),
        (MainStrings.tabMyPage, "PickpleUser", 2)
    ]

    var body: some View {
        if #available(iOS 26.0, *) {
            // 선택 표시 캡슐을 각 탭 버튼의 .background에 직접 중첩하면, 그 안에서는
            // GlassEffectContainer/glassEffect가 아이콘과 뒤섞여 제대로 안 나온다.
            // 그래서 버튼 안에는 위치/크기만 알려주는 투명한 matchedGeometryEffect
            // "소스" 마커만 심어두고, 실제로 유리가 적용된 캡슐은 완전히 분리된 레이어
            // (아이콘 행 밖, GlassEffectContainer 안)에서 그 소스의 프레임을 따라 움직이게
            // 한다 — 이러면 유리 렌더링이 아이콘과 절대 겹치지 않는다.
            HStack(spacing: 0) {
                ForEach(items, id: \.tag) { item in
                    tabButton(item)
                        .frame(maxWidth: .infinity)
                        .background {
                            if selectedTab == item.tag {
                                Color.clear
                                    .matchedGeometryEffect(id: "selectedTabGlass", in: glassNamespace, isSource: true)
                            }
                        }
                }
            }
            .padding(4)
            // .background로 붙여야 이 뷰(아이콘 행)의 실제 크기에 맞춰 바깥 유리 캡슐이
            // 그려진다 — ZStack으로 직접 겹치면 Capsule 자체엔 고유 크기가 없어서
            // 크기가 모호해진다. 안쪽 움직이는 캡슐은 matchedGeometryEffect가 크기/위치를
            // 직접 지정해주므로 이 배경의 크기 제안과 무관하게 소스(선택된 버튼)를 따라간다.
            .background {
                GlassEffectContainer {
                    ZStack {
                        Capsule()
                            .glassEffect(.regular, in: Capsule())

                        Capsule()
                            .glassEffect(.regular.tint(Color.neutral10), in: Capsule())
                            .matchedGeometryEffect(id: "selectedTabGlass", in: glassNamespace, isSource: false)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.2), value: selectedTab)
        } else {
            HStack(spacing: 0) {
                ForEach(items, id: \.tag) { item in
                    tabButton(item)
                        .frame(maxWidth: .infinity)
                }
            }
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

    private func tabButton(_ item: (title: String, icon: String, tag: Int)) -> some View {
        Button(action: { selectedTab = item.tag }) {
            VStack(spacing: 1) {
                Image(item.icon)
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(selectedTab == item.tag ? Color.black : Color.neutral30)
                    .padding(.horizontal, 29)
                Text(item.title)
                    .pickpleTypography(.caption)
                    .foregroundStyle(selectedTab == item.tag ? Color.black : Color.neutral30)
            }
            
            .padding(.horizontal, 10)
            .padding(.top, 6)
            .padding(.bottom, 7)
        }
    }
}

#Preview {
    VStack {
        CustomTabBar(selectedTab: .constant(1))
    }
}
