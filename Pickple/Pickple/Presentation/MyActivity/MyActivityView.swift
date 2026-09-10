//
//  MyActivityView.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//

import SwiftUI

struct MyActivityView: View {
    @State var myActivityViewModel: MyActivityViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var isShown: Bool = false
    @State private var selectedIndexTwo = 0
    @State private var selectedValue = MyActivityStrings.latestSortOption

    var body: some View {
        VStack {
            PickpleGNB(
                leading: .button(icon: Image("PickpleArrowLeft"), action: { dismiss() }),
                center: .text(MyActivityStrings.title),
                trailing: .none
            )

            PickpleTabBar(tabs: MyActivityStrings.tabs, selectedIndex: $selectedIndexTwo)
                .padding(.horizontal, 20)

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
            
            switch selectedIndexTwo {
            case 0:
                MyActivityListView(
                    items: myActivityViewModel.sorted(myActivityViewModel.votedPosts, by: selectedValue),
                    onReachEnd: { post in Task { await myActivityViewModel.loadMoreVotedPostsIfNeeded(currentPost: post) } }
                ) { post in
                    MyActivityVotedPostCardView(post: post)
                }
                .task { await myActivityViewModel.loadVotedPosts() }

            case 1:
                MyActivityListView(items: myActivityViewModel.sorted(myActivityViewModel.commentedActivities, by: selectedValue)) { activity in
                    MyActivityCommentActivityRow(activity: activity)
                }
                .task { await myActivityViewModel.loadCommentedPosts() }
            case 2:
                MyActivityListView(
                    items: myActivityViewModel.sorted(myActivityViewModel.writtenPosts, by: selectedValue),
                    onReachEnd: { post in Task { await myActivityViewModel.loadMoreWrittenPostsIfNeeded(currentPost: post) } }
                ) { post in
                    MyActivityWrittenPostCardView(post: post)
                }
                .task { await myActivityViewModel.loadWrittenPosts() }
            default:
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MyActivityView(myActivityViewModel: MyActivityViewModel(userPostRepository: MockUserPostRepository()))
}
