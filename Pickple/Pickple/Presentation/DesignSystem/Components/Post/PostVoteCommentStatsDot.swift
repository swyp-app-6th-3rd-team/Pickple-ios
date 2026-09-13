//
//  PostVoteCommentStats.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//
// 1차 점검 완료 - 9월 12일

import SwiftUI

struct PostVoteCommentStatsDot: View {
    let type: VoteType
    let voteCount: Int
    let commentCount: Int
    var showsTrailingDot: Bool = false
    
    var body: some View {
        HStack(spacing: 6) {
            if type != .text {
                HStack(spacing: 4) {
                    Image("PickpleVote")
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text("\(voteCount)")
                        .lineLimit(1)
                        .fixedSize()
                }

                Text("·")
            }

            HStack(spacing: 4) {
                Image("PickpleComment")
                    .resizable()
                    .frame(width: 16, height: 16)
                Text("\(commentCount)")
                    .lineLimit(1)
                    .fixedSize()
            }
            
            
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        PostVoteCommentStats(type: .forAgainst, voteCount: 12, commentCount: 4)
        PostVoteCommentStats(type: .text, voteCount: 0, commentCount: 5)
        PostVoteCommentStats(type: .forAgainst, voteCount: 12, commentCount: 4)
    }
    .pickpleTypography(.label)
    .foregroundStyle(Color.neutral30)
    .padding()
}
