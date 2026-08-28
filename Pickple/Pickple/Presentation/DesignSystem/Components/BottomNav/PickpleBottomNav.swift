//
//  PickpleBottomNav.swift
//  Pickple
//
//  Created by 박윤수 on 8/28/26.
//
//  아이콘 에셋 하나(비선택 색이 고정으로 박혀있는 원본)만 두고,
//  renderingMode를 선택 여부에 따라 바꾼다.
//  - 비선택: .original → 에셋에 박힌 원래 색 그대로
//  - 선택: .template → 알파만 남아서 .tint()가 적용됨
//  이러면 .tint()가 실제로 선택된 탭에만 영향을 주고, 비선택 탭은 항상
//  에셋 고유 색을 유지한다. PickpleHomeSelected 같은 별도 에셋도 필요 없다.
//

import SwiftUI

struct PickpleBottomNav: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            LoginView()
                .tabItem {
                    Label {
                        Text("홈")
                    } icon: {
                        Image("PickpleHome")
                            .renderingMode(selectedTab == 0 ? .template : .original)
                    }
                }
                .tag(0)

            LoginView()
                .tabItem {
                    Label {
                        Text("커뮤니티")
                    } icon: {
                        Image("PickpleMessage")
                            .renderingMode(selectedTab == 1 ? .template : .original)
                    }
                }
                .tag(1)

            LoginView()
                .tabItem {
                    Label {
                        Text("마이")
                    } icon: {
                        Image("PickpleUser")
                            .renderingMode(selectedTab == 2 ? .template : .original)
                    }
                }
                .tag(2)
        }
        .tint(Color.navy60)
    }
}

#Preview {
    PickpleBottomNav()
}
