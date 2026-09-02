//
//  MyActivityView.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//

import SwiftUI

struct MyActivityView: View {
    @StateObject var myActivityViewModel: MyActivityViewModel
    
    @State private var isShown: Bool = false
    @State private var selectedIndexTwo = 0
    @State private var selectedValue = "최신순"
    
    var body: some View {
        VStack {
            PickpleGNB(
                leading: .button(icon: Image("PickpleArrowLeft"), action: {}),
                center: .text("나의 활동"),
                trailing: .none
            )
            
            PickpleTabBar(tabs: ["투표", "댓글", "작성글"], selectedIndex: $selectedIndexTwo)
                .padding(.horizontal, 20)
            
            HStack {
                PickpleSortButton(isExpanded: .constant(false), selectedValue: $selectedValue, options: ["최신순", "오래된 순"])
                    .floatingOverSiblings {
                        PickpleSortButton(isExpanded: $isShown, selectedValue: $selectedValue, options: ["최신순", "오래된 순"])
                    }
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.vertical, 12)
            .zIndex(1)
            
            switch selectedIndexTwo {
            case 0:
                MyActivityPostListView(posts: myActivityViewModel.sorted(myActivityViewModel.votedPosts, by: selectedValue))
                    .task { await myActivityViewModel.loadVotedPosts() }
                
            case 1: MyActivityPostListView(posts: myActivityViewModel.sorted(myActivityViewModel.commentedPosts, by: selectedValue))
                    .task { await myActivityViewModel.loadCommentedPosts() }
            case 2:
                MyActivityPostListView(posts: myActivityViewModel.sorted(myActivityViewModel.writtenPosts, by: selectedValue))
                    .task { await myActivityViewModel.loadWrittenPosts() }
            default:
                EmptyView()
            }
        }
    }
}

#Preview {
    MyActivityView(myActivityViewModel: MyActivityViewModel(userPostRepository: MockUserPostRepository()))
}
