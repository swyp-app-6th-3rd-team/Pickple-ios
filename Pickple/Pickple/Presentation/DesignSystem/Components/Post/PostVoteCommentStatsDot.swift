//
//  PostVoteCommentStats.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  게시글 카드들이 각자 구현하던 "투표수 아이콘+숫자 / 댓글수 아이콘+숫자" 한 쌍을 공용화했다.
//  타이포그래피/색상은 호출부에서 이 뷰 위에 얹은 modifier가 environment로 전파되어 적용된다.
//  text 타입은 투표 기능이 없는 게시글이라 투표수를 아예 숨기고 댓글수만 보여준다.
//  showsTrailingDot: 통계 뒤에 "·"만 붙이는 옵션 — 시간 텍스트는 컴포넌트 책임이 아니라
//  호출부가 이 점 바로 뒤에 자기가 원하는 시간 텍스트를 이어붙인다.
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
            }
            
            Text("·")
            
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
