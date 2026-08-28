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
                    Label("홈", systemImage: "house")
                }
            LoginView()
                .tabItem {
                    Label("홈", systemImage: "house")
                }
            LoginView()
                .tabItem {
                    Label("홈", systemImage: "house")
                }
        }
    }
}

#Preview {
    PickpleBottomNav()
}
