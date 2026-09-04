//
//  SwiftUIView.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//

import SwiftUI

struct MyPagePostView: View {
    @ObservedObject var myPageViewModel: MyPageViewModel
    var onTapPost: (PostSummary) -> Void = { _ in }
    var onTapMore: () -> Void = {}

    var body: some View {
        VStack(spacing: 12){

            MyPagePostTitleView(onTapMore: onTapMore)
                .padding(.horizontal, 20)

            //MARK: - Post
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    if myPageViewModel.posts.isEmpty {
                        MyPagePostCardEmptyView()
                    }
                    else {
                        ForEach(myPageViewModel.posts) { post in
                            Button(action: { onTapPost(post) }) {
                                PostSummaryCardView(post: post)
                            }
                            .frame(width: 160, height: 238)

                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .task {
            await myPageViewModel.loadMyPosts()
        }
        .padding(.vertical, 16)
        .background(Color.white)
    }
}

#Preview {
    MyPagePostView(myPageViewModel: MyPageViewModel())
}
