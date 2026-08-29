//
//  PickpleApp.swift
//  Pickple
//
//  Created by 박윤수 on 8/24/26.
//

import SwiftUI

@main
struct PickpleApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LoginView()
            }
        }
    }
}
