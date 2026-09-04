//
//  PickpleApp.swift
//  Pickple
//
//  Created by 박윤수 on 8/24/26.
//

import SwiftUI

@main
struct PickpleApp: App {
    @State private var isLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                PickpleBottomNav()
            } else {
                NavigationStack {
                    LoginView(onLoginSuccess: { isLoggedIn = true })
                }
            }
        }
    }
}
