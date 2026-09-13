//
//  MyActivityWrittenPostCardView.swift
//  Pickple
//
//  Created by 박윤수 on 9/9/26.
//
// 1차 점검 완료 - 9월 13일

import SwiftUI

struct MyActivityWrittenPostCardView: View {
    let post: PostSummary

    var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    MyActivityPostCardTitle(title: post.title, decription: post.description)
                    
                    MyActivityStatsRow(type: post.type, voteCount: post.voteCount, commentCount: post.commentCount, createdAt: post.createdAt)
                }

                Spacer()

                PostCardImage(url: post.thumbnailUrl, type: post.type)
            }        
    }
}

#Preview {
    MyActivityWrittenPostCardView(
        post: PostSummary(
            id: 3,
            type: .text,
            category: "생활용품",
            title: "이 청소기 써본 사람?",
            description: "무선 청소기 사려는데 흡입력이랑 배터리 오래가는 제품 추천 좀요.",
            thumbnailUrl: nil,
            authorProfileImageUrl: nil,
            voteCount: 0,
            commentCount: 1,
            createdAt: Date().addingTimeInterval(-60 * 60 * 24)
        )
    )
}
