//
//  CommunitySearchResultCardView.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 여백/폰트 크기는 임시값

import SwiftUI

struct CommunitySearchResultCardView: View {
    let post: PostSummary

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                PostTypeBadge(type: post.type)

                    Text(post.title)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.black)
                        .lineLimit(1)
                
                Spacer()

                    
                    HStack(spacing: 6) {
                        PostVoteCommentStats(voteCount: post.voteCount, commentCount: post.commentCount)

                        Text("·")
                        
                        Text(post.createdAt.relativeTimeDescription)
                            .pickpleTypography(.caption)
                            .foregroundStyle(Color.neutral40)
                    }
                    .pickpleTypography(.label)
                    .foregroundStyle(Color.neutral30)
                
            }
            .frame(height: 100)
            .padding(.vertical, 4)
            
            Spacer()
            
            if post.type != .text {
                AsyncImage(url: post.thumbnailUrl) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Image("McokMyPostPicture").resizable().scaledToFill()
                }
                .frame(width: 120, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .clipped()
            }
        }

    }
}

#Preview {
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
