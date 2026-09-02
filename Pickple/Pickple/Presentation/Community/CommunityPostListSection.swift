//
//  CommunityPostListSection.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

struct CommunityPostListSection: View {
    @ObservedObject var communityViewModel: CommunityViewModel

    var body: some View {
        if communityViewModel.displayedPosts.isEmpty {
            CommunityEmptyView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ScrollView {
                LazyVStack(spacing: 20) {
                    Color.clear
                        .frame(height: 0)
                        .id("communityTop")

                    ForEach(communityViewModel.displayedPosts) { post in
                        CommunityPostCardView(post: post)

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
