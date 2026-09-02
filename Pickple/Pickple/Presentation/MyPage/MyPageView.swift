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
            
            VStack(spacing: 4) {
                MyPageProfileHeaderView(myPageViewModel: myPageViewModel)
                    .padding(.top, 30)
                    .padding(.bottom, 16)

                VStack(spacing: 0) {
                    MyPageStatusView(myPageViewModel: myPageViewModel)

                    Rectangle()
                        .fill(Color.neutral5)
                        .frame(height: 4)

                    MyPagePostView(myPageViewModel: myPageViewModel)
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
