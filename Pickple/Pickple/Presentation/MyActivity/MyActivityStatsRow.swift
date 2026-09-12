//
//  MyActivityStatsRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/13/26.
//
//  나의 활동 카드 3종(투표/작성글/댓글)이 공통으로 쓰는 "투표수·댓글수·작성시각" 한 줄.
// 1차 점검 완료 - 9월 13일

import SwiftUI

struct MyActivityStatsRow: View {
    let type: VoteType
    let voteCount: Int
    let commentCount: Int
    let createdAt: Date

    var body: some View {
        HStack(spacing: 6) {
            PostVoteCommentStatsDot(type: type, voteCount: voteCount, commentCount: commentCount)
            Text("·")
            Text(createdAt.relativeTimeDescription)
        }
        .pickpleTypography(.label)
        .foregroundStyle(Color.neutral30)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        MyActivityStatsRow(type: .forAgainst, voteCount: 12, commentCount: 4, createdAt: Date().addingTimeInterval(-60 * 5))
        MyActivityStatsRow(type: .text, voteCount: 0, commentCount: 5, createdAt: Date().addingTimeInterval(-60 * 60))
    }
    .padding()
}
