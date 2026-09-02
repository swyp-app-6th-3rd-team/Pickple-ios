//
//  SwiftUIView.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//

import SwiftUI

struct MyPagePostView: View {
    @ObservedObject var myPageViewModel: MyPageViewModel
    
    var body: some View {
        VStack(spacing: 12){
            
            MyPagePostTitleView()
                .padding(.horizontal, 20)

            //MARK: - Post
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(myPageViewModel.posts) { post in
                        Button(action: {}) {
                            PostSummaryCardView(post: post)
                        }
                    }
                }
                .padding(.horizontal, 20)

            }
            
        }
        .padding(.vertical, 16)
        
        .background(Color.white)
        .task {
            await myPageViewModel.loadMyPosts()
        }
    }
}

#Preview {
    MyPagePostView(myPageViewModel: MyPageViewModel())
}
