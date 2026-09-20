//
//  SwiftUIView.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//
// 1차 점검 완료 - 9월 13일


import SwiftUI

struct MyPagePostView: View {
    let myPageViewModel: MyPageViewModel
    var onTapPost: (PostSummary) -> Void = { _ in }
    var onTapMore: () -> Void = {}
    var onTapAddPost: () -> Void = {}

    var body: some View {
        VStack(spacing: 12){

            MyPagePostTitleView(onTapMore: onTapMore)
                .padding(.horizontal, 20)

            //MARK: - Post
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    if myPageViewModel.posts.isEmpty {
                        MyPagePostCardEmptyView(action: onTapAddPost)
                    }
                    else {
                        ForEach(myPageViewModel.posts) { post in
                            Button(action: { onTapPost(post) }) {
                                PostThumbnailCardView(post: post)
                            }
                            .frame(width: 160, height: 238)
                            .task { prefetchUpcomingImages(after: post) }
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

    // 가로 캐러셀이라 다음 3장을 미리 받아둔다 — PostThumbnailCardView와 같은 target size.
    private func prefetchUpcomingImages(after post: PostSummary) {
        guard let index = myPageViewModel.posts.firstIndex(where: { $0.id == post.id }) else { return }
        let urls = myPageViewModel.posts[index...].dropFirst().prefix(3).compactMap { $0.thumbnailUrl }
        PickpleImagePrefetcher.prefetch(urls: urls, targetSize: CGSize(width: 160, height: 160))
    }
}

#Preview {
    MyPagePostView(myPageViewModel: MyPageViewModel())
}
