//
//  MyActivityVotedPostCardView.swift
//  Pickple
//
//  Created by 박윤수 on 9/9/26.
//
// 1차 점검 완료 - 9월 13일
// 시간 폰트 미정


import SwiftUI

struct MyActivityVotedPostCardView: View {
    let post: PostSummary

    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    MyActivityPostCardTitle(title: post.title, decription: post.description)

                    MyActivityStatsRow(type: post.type, voteCount: post.voteCount, commentCount: post.commentCount, createdAt: post.createdAt)
                }
                
                Spacer()

                MyActivityPostCardImage(url: post.thumbnailUrl, type: post.type)
            }

            if let voteResult = post.voteResult {
                PostDetailVoteButtons(
                    firstLabel: voteResult.firstLabel,
                    secondLabel: voteResult.secondLabel,
                    votedSide: voteResult.votedSide,
                    firstPercentage: voteResult.firstPercentage,
                    secondPercentage: voteResult.secondPercentage,
                    myProfileImageUrl: nil,
                    onVote: { _ in }
                )
                .frame(height: 48)
            }
        }
    }
}

#Preview("찬반 70/30") {
    MyActivityVotedPostCardView(
        post: PostSummary(
            id: 1,
            type: .forAgainst,
            category: "전자제품",
            title: "노트북 살까 말까",
            description: "재택근무용으로 하나 더 살까 하는데 이미 있는 거로 버텨야 할지 고민이네요.",
            thumbnailUrl: nil,
            authorProfileImageUrl: nil,
            voteCount: 24,
            commentCount: 9,
            createdAt: Date().addingTimeInterval(-60 * 30),
            voteResult: PostVoteResult(firstLabel: "사자", secondLabel: "말자", firstPercentage: 70, secondPercentage: 30, votedSide: .first)
        )
    )
}

#Preview("비교픽 40/60") {
    MyActivityVotedPostCardView(
        post: PostSummary(
            id: 2,
            type: .ab,
            category: "화장품/뷰티",
            title: "선크림 A vs B",
            description: "여름 다가오는데 백탁 없고 산뜻한 걸로 고르려니 둘 중 뭐가 나을지 모르겠어요.",
            thumbnailUrl: nil,
            authorProfileImageUrl: nil,
            voteCount: 15,
            commentCount: 3,
            createdAt: Date().addingTimeInterval(-60 * 60 * 6),
            voteResult: PostVoteResult(firstLabel: "A", secondLabel: "B", firstPercentage: 40, secondPercentage: 60, votedSide: .second)
        )
    )
}
