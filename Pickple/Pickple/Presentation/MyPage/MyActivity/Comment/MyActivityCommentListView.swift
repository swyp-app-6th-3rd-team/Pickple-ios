//
//  MyActivityCommentListView.swift
//  Pickple
//
//  Created by 박윤수 on 10/2/26.
//
//  나의 활동 > 댓글 탭 목록. 리포지토리(fetchCommentedPosts)가 모든 페이지를 한 번에 받아와서 다음 페이지 요청이 없다.

import SwiftUI

struct MyActivityCommentListView: View {
    let myActivityViewModel: MyActivityViewModel
    var onTapActivity: (MyCommentActivity) -> Void = { _ in }

    var body: some View {
        if myActivityViewModel.commentedActivities.isEmpty {
            MyActivityEmptyView()
        } else {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(myActivityViewModel.commentedActivities) { activity in
                        Button(action: { onTapActivity(activity) }) {
                            MyActivityCommentActivityRow(activity: activity)
                                .multilineTextAlignment(.leading)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .task { prefetchUpcomingImages(after: activity) }

                        Divider()
                            .foregroundStyle(Color.navy10)
                    }
                }
            }
        }
    }

    private func prefetchUpcomingImages(after activity: MyCommentActivity) {
        let activities = myActivityViewModel.commentedActivities
        guard let index = activities.firstIndex(where: { $0.id == activity.id }) else { return }
        let urls = activities[index...].dropFirst().prefix(3).compactMap { $0.referencedPost.thumbnailUrl }
        PickpleImagePrefetcher.prefetch(urls: urls, targetSize: CGSize(width: 72, height: 72))
    }
}

#Preview {
    let viewModel = MyActivityViewModel(userPostRepository: MockUserPostRepository())
    MyActivityCommentListView(myActivityViewModel: viewModel)
        .task { await viewModel.loadCommentedPosts(sort: .latest) }
}
