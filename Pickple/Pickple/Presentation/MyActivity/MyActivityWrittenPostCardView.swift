//
//  MyActivityWrittenPostCardView.swift
//  Pickple
//
//  Created by 박윤수 on 9/9/26.
//
//  나의 활동 '작성글' 탭 전용 카드. 내가 올린 글이라 투표 결과 바는 항상 필요 없어서
//  투표 탭 카드(MyActivityVotedPostCardView)와 레이아웃은 같지만 그 부분만 뺐다.

import SwiftUI

struct MyActivityWrittenPostCardView: View {
    let post: PostSummary

    var body: some View {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    MyActivityPostCardTitle(title: post.title, decription: post.description)
                    
                    MyActivityStatsRow(type: post.type, voteCount: post.voteCount, commentCount: post.commentCount, createdAt: post.createdAt)
                }

                Spacer()

                MyActivityPostCardImage(url: post.thumbnailUrl, type: post.type)
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
