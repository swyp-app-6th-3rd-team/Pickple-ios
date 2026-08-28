//
//  PickpleBottomNav.swift
//  Pickple
//
//  Created by 박윤수 on 8/28/26.
//

import SwiftUI



struct PickpleBottomNav: View {
    var body: some View {
        
        TabView {
            LoginView()
                .tabItem {
                    Label("홈", image: "PickpleHome")
                }
            LoginView()
                .tabItem {
                    Label("커뮤니티", image: "PickpleMessage")
                }
            LoginView()
                .tabItem {
                    Label("마이", image: "PickpleUser")
                }
        }
        .tint(.navy60)
    }
}

#Preview {
    PickpleBottomNav()
}
