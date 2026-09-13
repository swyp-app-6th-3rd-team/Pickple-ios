//
//  PostThumbnailCardView.swift
//  Pickple
//
//  Created by 박윤수 on 9/13/26.
//
// 1차 점검 완료 - 9월 13일


import SwiftUI

struct PostThumbnailCardView: View {
    let post: PostSummary
    var showsAuthorNickname: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                AsyncImage(url: post.thumbnailUrl) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Image("McokMyPostPicture").resizable().scaledToFill()
                }
                .frame(width: 160, height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .clipped()

                PostTypeBadge(type: post.type, iconSize: 16, typography: .label, horizontalPadding: 10)
                    .padding(10)
            }

            VStack(spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(post.category)
                            .pickpleTypography(.caption)
                            .foregroundStyle(Color.neutral50)

                        Text(post.title)
                            .pickpleTypography(.body01)
                            .foregroundStyle(Color.black)
                            .lineLimit(1)
                    }
                    Spacer()
                }

                HStack(spacing: 8) {
                    PostVoteCommentStats(type: post.type, voteCount: post.voteCount, commentCount: post.commentCount)
                        .pickpleTypography(.caption)
                        .foregroundStyle(Color.neutral20)

                    Spacer()

                    if showsAuthorNickname, let authorNickname = post.authorNickname {
                        HStack(spacing: 8) {
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
                    }

                    Text(post.createdAt.relativeTimeDescription)
                        .lineLimit(1)
                        .pickpleTypography(.caption)
                        .foregroundStyle(Color.neutral20)
                }
                .padding(.horizontal, 2)
            }
        }
        .frame(width: 160)
        .contentShape(Rectangle())
    }
}

#Preview {
    PostThumbnailCardView(
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
