//
//  CommunitySearchResultCardView.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
// 1차 점검 완료 - 9월 12일
// post stat 폰트 미지정

import SwiftUI

struct CommunitySearchResultCardView: View {
    let post: PostSummary

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.title)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.black)
                        .lineLimit(1)
                    
                    //설명 공백 대비
                    Text(post.description.isEmpty ? " " : post.description)
                        .pickpleTypography(.body02)
                        .foregroundStyle(Color.neutral40)
                        .lineLimit(1)
                }
                
                HStack(spacing: 4) {
                    PostVoteCommentStatsDot(
                        type: post.type,
                        voteCount: post.voteCount,
                        commentCount: post.commentCount,
                    )
                    
                    Text("·")
                    
                    Text(post.createdAt.relativeTimeDescription)
                }
                //.pickpleTypography(.heading02) 폰트 미지정
                .foregroundStyle(Color.neutral30)
            }
            
            Spacer()
            
            PostCardImage(type: post.type)
        }
        .padding(.vertical, 20)

    }
}

#Preview("설명 있음") {
    CommunitySearchResultCardView(
        post: PostSummary(
            id: 1,
            type: .forAgainst,
            category: "패션/잡화",
            title: "나이키 에어포스 흰색으로 살까?",
            description: "데일리로 신을건데 나이키 에어포스 흰색 어때? 흰색 때타고 별로이려나? 검은색은 이미 있어서 이번엔 흰 색도 사보려는데 어떻게 생각해?",
            thumbnailUrl: nil,
            authorNickname: "닉네임",
            authorLevel: 5,
            authorProfileImageUrl: nil,
            voteCount: 3,
            commentCount: 1,
            createdAt: Date().addingTimeInterval(-60 * 5)
        )
    )
    .padding()
}

#Preview("설명 없음") {
    CommunitySearchResultCardView(
        post: PostSummary(
            id: 2,
            type: .forAgainst,
            category: "패션/잡화",
            title: "나이키 에어포스 흰색으로 살까?",
            description: "",
            thumbnailUrl: nil,
            authorNickname: "닉네임",
            authorLevel: 5,
            authorProfileImageUrl: nil,
            voteCount: 3,
            commentCount: 1,
            createdAt: Date().addingTimeInterval(-60 * 5)
        )
    )
    .padding()
}
