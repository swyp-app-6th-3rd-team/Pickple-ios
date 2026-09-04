//
//  CommunityPostListSection.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

struct CommunityPostListSection: View {
    @ObservedObject var communityViewModel: CommunityViewModel
    var onTapPost: (PostSummary) -> Void = { _ in }

    var body: some View {
        if communityViewModel.displayedPosts.isEmpty {
            CommunityEmptyView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ScrollView {
                LazyVStack(spacing: 20) {
                    Color.clear
                        .frame(height: 0)
                        .id(CommunityViewModel.scrollTopAnchor)

                    ForEach(communityViewModel.displayedPosts) { post in
                        CommunityPostCardView(post: post)
                            .onTapGesture { onTapPost(post) }

                        Divider()
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    CommunityPostListSection(communityViewModel: CommunityViewModel())
}
