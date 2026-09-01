//
//  MyPageView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//

import SwiftUI

struct MyPageView: View {
    @StateObject var myPageViewModel: MyPageViewModel
    
    var body: some View {
        ZStack {
            Color.navy60.ignoresSafeArea()
            
            VStack {
                MyPageProfileSectionView(myPageViewModel: myPageViewModel)
                
                MyPageStatusView(myPageViewModel: myPageViewModel)

            }
            .frame(maxWidth: .infinity)
            
            
        }
        .task {
            await myPageViewModel.loadUserInfo()
        }
    }
    
}

#Preview {
    MyPageView(myPageViewModel: MyPageViewModel())
}
