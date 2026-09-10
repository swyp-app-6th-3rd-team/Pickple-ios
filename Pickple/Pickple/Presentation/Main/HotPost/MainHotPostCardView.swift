//
//  MainHotPostCardView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 카드 폭/여백은 임시값

import SwiftUI

struct MainHotPostCardView: View {
    let post: PostSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                AsyncImage(url: post.thumbnailUrl) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Image("McokMyPostPicture").resizable().scaledToFill()
                }
                .frame(width: 150, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .clipped()

                PostTypeBadge(type: post.type, iconSize: 14, typography: .caption, horizontalPadding: 8)
                    .padding(8)
            }

            Text(post.category)
                .pickpleTypography(.caption)
                .foregroundStyle(Color.neutral50)

            Text(post.title)
                .pickpleTypography(.body02)
                .foregroundStyle(Color.black)
                .lineLimit(1)

            HStack(spacing: 8) {
                PostVoteCommentStats(voteCount: post.voteCount, commentCount: post.commentCount)
                    .layoutPriority(1)

                // 투표수/댓글수 자릿수가 늘어나 카드 폭(150pt)이 빠듯해지면, 상대적으로
                // 덜 중요한 "n분 전" 쪽이 먼저 줄어들도록 우선순위를 낮춘다.
                Text(post.createdAt.relativeTimeDescription)
                    .lineLimit(1)
            }
            .pickpleTypography(.caption)
            .foregroundStyle(Color.neutral30)
        }
        .frame(width: 150)
    }
}

#Preview {
    MainHotPostCardView(
        post: PostSummary(
            id: 1,
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
