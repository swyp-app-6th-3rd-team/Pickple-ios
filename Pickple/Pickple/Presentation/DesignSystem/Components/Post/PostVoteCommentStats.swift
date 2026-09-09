//
//  PostVoteCommentStats.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  게시글 카드들이 각자 구현하던 "투표수 아이콘+숫자 / 댓글수 아이콘+숫자" 한 쌍을 공용화했다.
//  타이포그래피/색상은 호출부에서 이 뷰 위에 얹은 modifier가 environment로 전파되어 적용된다.

import SwiftUI

struct PostVoteCommentStats: View {
    let voteCount: Int
    let commentCount: Int

    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 4) {
                Image("PickpleVote")
                    .resizable()
                    .frame(width: 16, height: 16)
                Text("\(voteCount)")
            }
            HStack(spacing: 4) {
                Image("PickpleComment")
                    .resizable()
                    .frame(width: 16, height: 16)
                Text("\(commentCount)")
            }
        }
    }
}

#Preview {
    PostVoteCommentStats(voteCount: 12, commentCount: 4)
        .pickpleTypography(.label)
        .foregroundStyle(Color.neutral30)
        .padding()
}
