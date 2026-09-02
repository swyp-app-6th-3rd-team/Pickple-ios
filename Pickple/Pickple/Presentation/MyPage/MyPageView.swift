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
            VStack(spacing: 0) {
                Color.navy60
                    .ignoresSafeArea()
                Color.white
                    .ignoresSafeArea()
            }
            ScrollView {
                    VStack(spacing: 0) {
                        MyPageProfileHeaderView(myPageViewModel: myPageViewModel)
                        
                        MyPageStatusView(myPageViewModel: myPageViewModel)
                        
                        Divider()
                            .frame(height: 4)
                            .background(Color.neutral5)
                        
                        MyPagePostView(myPageViewModel: myPageViewModel)
                        
                        Divider()
                            .frame(height: 4)
                            .background(Color.neutral5)
                        
                        MyPageInfoView()
                        
                        Divider()
                            .frame(height: 4)
                            .background(Color.neutral5)
                        
                        MyPageExtraView()
                        
                    }
                
            }
        }
        .task {
            await myPageViewModel.loadUserInfo()
            await myPageViewModel.loadMyPosts()
        }
    }
}

#Preview {
    MyPageView(myPageViewModel: MyPageViewModel())
}
