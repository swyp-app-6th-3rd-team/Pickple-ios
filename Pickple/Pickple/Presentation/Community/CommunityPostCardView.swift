//
//  CommunityPostCardView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 썸네일 높이/여백은 임시값

import SwiftUI

struct CommunityPostCardView: View {
    let post: PostSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                AsyncImage(url: post.thumbnailUrl) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Image("McokMyPostPicture").resizable().scaledToFill()
                }
                .frame(height: 160)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .clipped()

                PostTypeBadge(type: post.type)
                    .padding(10)
            }

            Text(post.title)
                .pickpleTypography(.body01)
                .foregroundStyle(Color.black)

            Text(post.description)
                .pickpleTypography(.body02)
                .foregroundStyle(Color.neutral50)
                .lineLimit(2)

            HStack {
                PostVoteCommentStats(voteCount: post.voteCount, commentCount: post.commentCount)
                    .pickpleTypography(.label)
                    .foregroundStyle(Color.neutral30)

                Spacer()

                HStack(spacing: 8) {
                    if let authorNickname = post.authorNickname {
                        HStack(spacing: 2) {
                            Text(authorNickname)
                                .pickpleTypography(.caption)
                                .foregroundStyle(Color.neutral40)

                            if let authorLevel = post.authorLevel {
                                Image("PickpleLevelBadge\(authorLevel)")
                                    .resizable()
                                    .frame(width: 14, height: 14)
                            }
                        }

                        Divider()
                            .frame(height: 12)
                    }

                    Text(post.createdAt.relativeTimeDescription)
                        .pickpleTypography(.caption)
                        .foregroundStyle(Color.neutral40)
                }
            }
        }
    }
}

#Preview {
    CommunityPostCardView(
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
