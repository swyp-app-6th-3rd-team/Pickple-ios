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
            HStack(spacing: -8) {
                ForEach(items, id: \.tag) { item in
                    tabButton(item)
                        .background {
                            if selectedTab == item.tag {
                                Color.clear
                                    .matchedGeometryEffect(id: "selectedTabGlass", in: glassNamespace, isSource: true)
                            }
                        }
                }
            }
            .padding(4)
            .background {
                GlassEffectContainer {
                    ZStack {
                        Capsule()
                            .foregroundStyle(Color.white)
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
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State private var selectedTab = 1

    var body: some View {
        VStack {
            Spacer()
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}
