//
//  MyActivityPostListView.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//

import SwiftUI

struct MyActivityPostListView: View {
    let posts: [PostSummary]

    var body: some View {
        if posts.isEmpty {
            VStack(spacing: 20) {
                Spacer()
                Text(MyActivityStrings.emptyMessage)
                Spacer()
            }
        } else {
            ScrollView {
                ForEach(posts) { post in
                    Button(action: {}) {
                        PostSummaryCardView(post: post, showsAuthorNickname: true)
                    }
                    Divider()
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, 20)
            }
        }
    }
}


