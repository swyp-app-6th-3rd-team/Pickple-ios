//
//  MyActivityVotedPostCardView.swift
//  Pickple
//
//  Created by 박윤수 on 9/9/26.
//
//  나의 활동 '투표' 탭 전용 카드. 작성글 탭과 레이아웃은 같지만 투표 결과를 항상 함께 보여준다.
//  결과 바는 게시글 상세와 같은 PostDetailVoteButtons를 그대로 재사용한다(따로 만들면 계속
//  따로 관리하다 서로 어긋난다) — 이미 투표한 상태로 넘겨서 읽기 전용처럼 보이게 한다.
//  TODO: 실제 API(GET /users/me/activities?type=VOTE)엔 득표율 필드가 없어서, voteResult는
//  아직 Mock에서만 채워진다 — 실 서버 데이터로는 결과 바가 안 보인다.

import SwiftUI

struct MyActivityVotedPostCardView: View {
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
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        PostVoteCommentStats(voteCount: post.voteCount, commentCount: post.commentCount)
                        
                        Text("·")
                        
                        Text(post.createdAt.relativeTimeDescription)
                            .pickpleTypography(.caption)
                            .foregroundStyle(Color.neutral40)
                    }
                    .pickpleTypography(.label)
                    .foregroundStyle(Color.neutral30)
                }
                .frame(height: 72)
                
                Spacer()
                
                ZStack(alignment: .topLeading) {
                    AsyncImage(url: post.thumbnailUrl) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Image("McokMyPostPicture").resizable().scaledToFill()
                    }
                    .frame(width: 72, height: 72)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .clipped()
                    
                    ZStack(alignment: .center) {
                        UnevenRoundedRectangle(
                            topLeadingRadius: 8,
                            bottomTrailingRadius: 8
                        )
                        .frame(width: 24 ,height: 24)
                        .foregroundStyle(Color.black.opacity(0.4))
                        
                        switch post.type {
                        case .text:
                            Image("PickpleText")
                                .resizable()
                                .frame(width: 16, height: 16)
                        case .forAgainst:
                            Image("PickpleAgainst")
                                .resizable()
                                .frame(width: 16, height: 16)
                        case .ab:
                            Image("PickpleAB")
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                    }
                }
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
    .padding()
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
    .padding()
}
