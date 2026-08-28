//
//  MainView.swift
//  Pickple
//
//  Created by 박윤수 on 8/28/26.
//
import SwiftUI

struct MainView: View {
    @State var selectedTab: Int = 0
    var body: some View {
        VStack {
                VStack {
                    PickpleGNB(
                        leading: .text("Pickple"),
                        center: .none,
                        trailing: .button(icon: Image("PickpleAlertOff"), action: {})
                    )
                    
                    //추후 알림 버튼 구현
                    
                    PickpleTabBar(tabs: ["찬반", "AB"], selectedIndex: $selectedTab)
                    
                    
                }
                .background(Color.navy60)
            
            if selectedTab == 0 {
                Text("A")
            } else {
                Text("B")
                
            }
                
            Spacer()
        }
    }
}

#Preview {
    MainView()
}
