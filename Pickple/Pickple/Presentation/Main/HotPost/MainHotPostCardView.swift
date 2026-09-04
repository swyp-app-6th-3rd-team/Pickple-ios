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
                Image(post.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .clipped()

                HStack(spacing: 4) {
                    switch post.type {
                    case .text: Image("PickpleText").resizable().frame(width: 14, height: 14)
                    case .forAgainst: Image("PickpleAgainst").resizable().frame(width: 14, height: 14)
                    case .ab: Image("PickpleAB").resizable().frame(width: 14, height: 14)
                    }

                    Text(post.type.displayName)
                        .pickpleTypography(.caption)
                        .foregroundStyle(Color.white)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Capsule().foregroundStyle(Color.black))
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
                HStack(spacing: 2) {
                    Image("PickpleVote")
                        .resizable()
                        .frame(width: 12, height: 12)
                    Text("\(post.voteCount)")
                }

                HStack(spacing: 2) {
                    Image("PickpleComment")
                        .resizable()
                        .frame(width: 12, height: 12)
                    Text("\(post.commentCount)")
                }

                Text(post.createdAt.relativeTimeDescription)
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
            id: UUID(),
            type: .forAgainst,
            category: "패션/잡화",
            title: "나이키 에어포스 흰색으로 살까?",
            description: "",
            imageName: "McokMyPostPicture",
            authorNickname: "닉네임",
            authorLevel: 5,
            voteCount: 3,
            commentCount: 1,
            createdAt: Date().addingTimeInterval(-60 * 5)
        )
    )
    .padding()
}
