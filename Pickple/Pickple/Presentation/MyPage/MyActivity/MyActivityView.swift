//
//  MyActivityView.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//
// 1차 점검 완료 - 9월 12일

import SwiftUI

struct MyActivityView: View {
    @State var myActivityViewModel: MyActivityViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(MyPageRouter.self) private var myPageRouter

    @State private var isShown: Bool = false
    @State private var selectedTabIndex: Int
    @State private var selectedValue = MyActivityStrings.latestSortOption

    init(myActivityViewModel: MyActivityViewModel, initialTab: Int = 0) {
        _myActivityViewModel = State(initialValue: myActivityViewModel)
        _selectedTabIndex = State(initialValue: initialTab)
    }

    private var sortOrder: ActivitySortOrder {
        selectedValue == MyActivityStrings.latestSortOption ? .latest : .oldest
    }

    var body: some View {
        VStack(spacing: 0) {
            PickpleGNB(
                leading: .button(icon: Image("PickpleArrowLeft"), action: { dismiss() }),
                center: .text(MyActivityStrings.title),
                trailing: .none,
                bar: false
            )

            PickpleTabBar(tabs: MyActivityStrings.tabs, selectedIndex: $selectedTabIndex)

            HStack {
                PickpleSortButton(isExpanded: .constant(false), selectedValue: $selectedValue, options: MyActivityStrings.sortOptions)
                    .floatingOverSiblings {
                        PickpleSortButton(isExpanded: $isShown, selectedValue: $selectedValue, options: MyActivityStrings.sortOptions)
                    }
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.vertical, 12)
            .zIndex(1)
            
            Group {
                switch selectedTabIndex {
                case 0:
                    MyActivityListView(
                        items: myActivityViewModel.votedPosts,
                        onReachEnd: { post in Task { await myActivityViewModel.loadMoreVotedPostsIfNeeded(currentPost: post) } },
                        onTapItem: { post in myPageRouter.push(.postDetail(postId: post.id, type: post.type)) },
                        // MyActivityVotedPostCardView는 타입과 무관하게 항상 thumbnailUrl 한 장만 쓴다
                        // (CommunityPostCardView와 달리 A/B에서도 product 이미지로 안 바뀜).
                        prefetchImageURLs: { $0.thumbnailUrl.map { [$0] } ?? [] }
                    ) { post in
                        MyActivityVotedPostCardView(post: post)
                    }
                    .task { await myActivityViewModel.loadVotedPosts(sort: sortOrder) }

                case 1:
                    MyActivityListView(
                        items: myActivityViewModel.commentedActivities,
                        onTapItem: { activity in myPageRouter.push(.postDetail(postId: activity.referencedPost.id, type: activity.referencedPost.type)) },
                        prefetchImageURLs: { activity in activity.referencedPost.thumbnailUrl.map { [$0] } ?? [] }
                    ) { activity in
                        MyActivityCommentActivityRow(activity: activity)
                    }
                    .task { await myActivityViewModel.loadCommentedPosts(sort: sortOrder) }
                case 2:
                    MyActivityListView(
                        items: myActivityViewModel.writtenPosts,
                        onReachEnd: { post in Task { await myActivityViewModel.loadMoreWrittenPostsIfNeeded(currentPost: post) } },
                        onTapItem: { post in myPageRouter.push(.postDetail(postId: post.id, type: post.type)) },
                        prefetchImageURLs: { $0.thumbnailUrl.map { [$0] } ?? [] }
                    ) { post in
                        MyActivityWrittenPostCardView(post: post)
                    }
                    .task { await myActivityViewModel.loadWrittenPosts(sort: sortOrder) }
                default:
                    EmptyView()
                }
            }
            // 정렬 옵션을 바꾸면 현재 보고 있는 탭만 새 sort로 다시 처음부터 불러온다 —
            // 서버가 정렬을 해주므로 클라이언트에서 다시 섞을 필요가 없다.
            .onChange(of: selectedValue) { _, _ in
                Task {
                    switch selectedTabIndex {
                    case 0: await myActivityViewModel.loadVotedPosts(sort: sortOrder)
                    case 1: await myActivityViewModel.loadCommentedPosts(sort: sortOrder)
                    case 2: await myActivityViewModel.loadWrittenPosts(sort: sortOrder)
                    default: break
                    }
                }
            }
        }
        .background(Color.white.ignoresSafeArea())
        .collapsesOnTapOutside($isShown)
        .navigationBarBackButtonHidden(true)
        .restoresSwipeBackGesture()
    }
}

#Preview {
    MyActivityView(myActivityViewModel: MyActivityViewModel(userPostRepository: MockUserPostRepository()))
        .environment(MyPageRouter())
}
