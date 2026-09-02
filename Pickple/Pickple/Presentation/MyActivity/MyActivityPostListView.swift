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
                Text("아직 참여한 활동이 없어요")
                Spacer()
            }
        } else {
            ScrollView {
                ForEach(posts) { post in
                    Button(action: {}) {
                        PostSummaryCardView(post: post)
                    }
                    Divider()
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, 20)
            }
        }
    }
}


