//
//  MyPageView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//

import SwiftUI

struct MyPageView: View {
    @ObservedObject var myPageViewModel: MyPageViewModel
    @Environment(MyPageRouter.self) private var myPageRouter

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
                        
                        MyPagePostView(
                            myPageViewModel: myPageViewModel,
                            onTapPost: { post in myPageRouter.push(.postDetail(post.type)) },
                            onTapMore: { myPageRouter.push(.activity) }
                        )

                        Divider()
                            .frame(height: 4)
                            .background(Color.neutral5)

                        MyPageInfoView(
                            onTapGrade: { myPageRouter.push(.grade) },
                            onTapBadge: { myPageRouter.push(.badge) }
                        )

                        Divider()
                            .frame(height: 4)
                            .background(Color.neutral5)

                        MyPageExtraView(onTapAccount: { myPageRouter.push(.account) })
                        
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
        .environment(MyPageRouter())
}
