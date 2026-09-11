//
//  MyActivityPostVoteCommentStats.swift
//  Pickple
//
//  Created by 박윤수 on 9/11/26.
//
//  나의 활동 카드 전용. text 타입은 투표 기능이 없는 게시글이라 투표수를 아예 숨긴다
//  (다른 화면 카드들은 0으로 표시 — 여기만 예외라 공용 PostVoteCommentStats를 직접
//  바꾸지 않고 나의 활동 화면 전용으로 감쌌다).

import SwiftUI

struct MyActivityPostVoteCommentStats: View {
    var type: VoteType
    var voteCount: Int
    var commentCount: Int

    var body: some View {
        if type == .text {
            HStack(spacing: 4) {
                Image("PickpleComment")
                    .resizable()
                    .frame(width: 16, height: 16)
                Text("\(commentCount)")
                    .lineLimit(1)
                    .fixedSize()
            }
        } else {
            PostVoteCommentStats(voteCount: voteCount, commentCount: commentCount)
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        MyActivityPostVoteCommentStats(type: .forAgainst, voteCount: 12, commentCount: 4)
        MyActivityPostVoteCommentStats(type: .text, voteCount: 0, commentCount: 5)
    }
    .pickpleTypography(.label)
    .foregroundStyle(Color.neutral30)
    .padding()
}
