//
//  MyActivityWrittenListView.swift
//  Pickple
//
//  Created by 박윤수 on 10/2/26.
//
//  나의 활동 > 작성글 탭 목록.

import SwiftUI

struct MyActivityWrittenListView: View {
    let myActivityViewModel: MyActivityViewModel
    var onTapPost: (PostSummary) -> Void = { _ in }

    var body: some View {
        if myActivityViewModel.writtenPosts.isEmpty {
            MyActivityEmptyView()
        } else {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(myActivityViewModel.writtenPosts) { post in
                        Button(action: { onTapPost(post) }) {
                            MyActivityWrittenPostCardView(post: post)
                                .multilineTextAlignment(.leading)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .task {
                            await myActivityViewModel.loadMoreWrittenPostsIfNeeded(currentPost: post)
                            prefetchUpcomingImages(after: post)
                        }

                        Divider()
                            .foregroundStyle(Color.navy10)
                    }
                }
            }
        }
    }

    private func prefetchUpcomingImages(after post: PostSummary) {
        let posts = myActivityViewModel.writtenPosts
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        let urls = posts[index...].dropFirst().prefix(3).compactMap { $0.thumbnailUrl }
        PickpleImagePrefetcher.prefetch(urls: urls, targetSize: CGSize(width: 72, height: 72))
    }
}

#Preview {
    let viewModel = MyActivityViewModel(userPostRepository: MockUserPostRepository())
    MyActivityWrittenListView(myActivityViewModel: viewModel)
        .task { await viewModel.loadWrittenPosts(sort: .latest) }
}
