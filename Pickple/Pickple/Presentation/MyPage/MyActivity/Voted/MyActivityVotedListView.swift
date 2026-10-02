//
//  MyActivityVotedListView.swift
//  Pickple
//
//  Created by 박윤수 on 10/2/26.
//
//  나의 활동 > 투표 탭 목록.
// 1차 리팩토링 완료 - 10월 2일

import SwiftUI

struct MyActivityVotedListView: View {
    let myActivityViewModel: MyActivityViewModel
    var onTapPost: (PostSummary) -> Void = { _ in }

    var body: some View {
        if myActivityViewModel.votedPosts.isEmpty {
            MyActivityEmptyView()
        } else {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(myActivityViewModel.votedPosts) { post in
                        Button(action: { onTapPost(post) }) {
                            MyActivityVotedPostCardView(post: post)
                                .multilineTextAlignment(.leading)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .task {
                            await myActivityViewModel.loadMoreVotedPostsIfNeeded(currentPost: post)
                            prefetchUpcomingImages(after: post)
                        }

                        Divider()
                            .foregroundStyle(Color.navy10)
                    }
                }
            }
        }
    }

    // MyActivityVotedPostCardView는 타입과 무관하게 항상 thumbnailUrl 한 장만 쓴다
    // (CommunityPostCardView와 달리 A/B에서도 product 이미지로 안 바뀜).
    private func prefetchUpcomingImages(after post: PostSummary) {
        let posts = myActivityViewModel.votedPosts
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        let urls = posts[index...].dropFirst().prefix(3).compactMap { $0.thumbnailUrl }
        PickpleImagePrefetcher.prefetch(urls: urls, targetSize: CGSize(width: 72, height: 72))
    }
}

#Preview {
    let viewModel = MyActivityViewModel(userPostRepository: MockUserPostRepository())
    MyActivityVotedListView(myActivityViewModel: viewModel)
        .task { await viewModel.loadVotedPosts(sort: .latest) }
}
