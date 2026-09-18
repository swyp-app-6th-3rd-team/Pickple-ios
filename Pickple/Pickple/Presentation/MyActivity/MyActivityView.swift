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
                        items: myActivityViewModel.sorted(myActivityViewModel.votedPosts, by: selectedValue),
                        onReachEnd: { post in Task { await myActivityViewModel.loadMoreVotedPostsIfNeeded(currentPost: post) } },
                        onTapItem: { post in myPageRouter.push(.postDetail(postId: post.id, type: post.type)) }
                    ) { post in
                        MyActivityVotedPostCardView(post: post)
                    }
                    .task { await myActivityViewModel.loadVotedPosts() }

                case 1:
                    MyActivityListView(
                        items: myActivityViewModel.sorted(myActivityViewModel.commentedActivities, by: selectedValue),
                        onTapItem: { activity in myPageRouter.push(.postDetail(postId: activity.referencedPost.id, type: activity.referencedPost.type)) }
                    ) { activity in
                        MyActivityCommentActivityRow(activity: activity)
                    }
                    .task { await myActivityViewModel.loadCommentedPosts() }
                case 2:
                    MyActivityListView(
                        items: myActivityViewModel.sorted(myActivityViewModel.writtenPosts, by: selectedValue),
                        onReachEnd: { post in Task { await myActivityViewModel.loadMoreWrittenPostsIfNeeded(currentPost: post) } },
                        onTapItem: { post in myPageRouter.push(.postDetail(postId: post.id, type: post.type)) }
                    ) { post in
                        MyActivityWrittenPostCardView(post: post)
                    }
                    .task { await myActivityViewModel.loadWrittenPosts() }
                default:
                    EmptyView()
                }
            }
        }
        .background(Color.white.ignoresSafeArea())
        // 정렬 드롭박스가 펼쳐진 채로 화면 어디를 탭해도(리스트 밖의 헤더 빈 공간 포함)
        // 접히게 한다. 리스트/버튼의 탭·스크롤 제스처는 simultaneousGesture라 막지 않는다.
        // Spacer처럼 실제로 안 그려지는 빈 공간은 contentShape 없이는 히트테스트 영역이
        // 아니라 제스처 자체가 인식되지 않는다.
        .contentShape(Rectangle())
        .simultaneousGesture(
            TapGesture().onEnded {
                if isShown {
                    withAnimation(.spring()) {
                        isShown = false
                    }
                }
            }
        )
        .navigationBarBackButtonHidden(true)
        .restoresSwipeBackGesture()
    }
}

#Preview {
    MyActivityView(myActivityViewModel: MyActivityViewModel(userPostRepository: MockUserPostRepository()))
        .environment(MyPageRouter())
}
