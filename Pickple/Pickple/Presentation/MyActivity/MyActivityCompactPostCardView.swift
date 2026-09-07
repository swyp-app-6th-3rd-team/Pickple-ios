//
//  MyActivityCompactPostCardView.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  나의 활동 '투표'/'작성글' 탭 공용 카드. post.voteResult가 있으면(투표 탭) 결과 바를 같이
//  보여주고, 없으면(작성글 탭) 안 보여준다 — 탭별로 분기하지 않고 데이터 유무로만 결정한다.

import SwiftUI

struct MyActivityCompactPostCardView: View {
    let post: PostSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.title)
                        .lineLimit(1)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.black)

                    Text(post.description)
                        .lineLimit(1)
                        .pickpleTypography(.body02)
                        .foregroundStyle(Color.neutral50)
                }

                Spacer()

                AsyncImage(url: post.thumbnailUrl) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Image("McokMyPostPicture").resizable().scaledToFill()
                }
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .clipped()
            }

            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Image("PickpleVote")
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text("\(post.voteCount)")
                }

                HStack(spacing: 4) {
                    Image("PickpleComment")
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text("\(post.commentCount)")
                }

                Spacer()

                Text(post.createdAt.relativeTimeDescription)
                    .pickpleTypography(.caption)
                    .foregroundStyle(Color.neutral40)
            }
            .pickpleTypography(.label)
            .foregroundStyle(Color.neutral30)

            if let voteResult = post.voteResult {
                MyActivityVoteResultBar(result: voteResult)
            }
        }
    }
}

#Preview("찬반 70/30") {
    MyActivityCompactPostCardView(
        post: PostSummary(
            id: 1,
            type: .forAgainst,
            category: "전자제품",
            title: "노트북 살까 말까",
            description: "재택근무용으로 하나 더 살까 하는데 이미 있는 거로 버텨야 할지 고민이네요.",
            thumbnailUrl: nil,
            authorNickname: "라떼한잔",
            authorLevel: 3,
            authorProfileImageUrl: nil,
            voteCount: 24,
            commentCount: 9,
            createdAt: Date().addingTimeInterval(-60 * 30),
            voteResult: PostVoteResult(firstLabel: "사자", secondLabel: "말자", firstPercentage: 70, secondPercentage: 30)
        )
    )
    .padding()
}

#Preview("비교픽 40/60") {
    MyActivityCompactPostCardView(
        post: PostSummary(
            id: 2,
            type: .ab,
            category: "화장품/뷰티",
            title: "선크림 A vs B",
            description: "여름 다가오는데 백탁 없고 산뜻한 걸로 고르려니 둘 중 뭐가 나을지 모르겠어요.",
            thumbnailUrl: nil,
            authorNickname: "여름햇살",
            authorLevel: 5,
            authorProfileImageUrl: nil,
            voteCount: 15,
            commentCount: 3,
            createdAt: Date().addingTimeInterval(-60 * 60 * 6),
            voteResult: PostVoteResult(firstLabel: "A", secondLabel: "B", firstPercentage: 40, secondPercentage: 60)
        )
    )
    .padding()
}

#Preview("작성글(결과 없음)") {
    MyActivityCompactPostCardView(
        post: PostSummary(
            id: 3,
            type: .text,
            category: "생활용품",
            title: "이 청소기 써본 사람?",
            description: "무선 청소기 사려는데 흡입력이랑 배터리 오래가는 제품 추천 좀요.",
            thumbnailUrl: nil,
            authorNickname: "픽플닉네임",
            authorLevel: 1,
            authorProfileImageUrl: nil,
            voteCount: 0,
            commentCount: 1,
            createdAt: Date().addingTimeInterval(-60 * 60 * 24)
        )
    )
    .padding()
}
