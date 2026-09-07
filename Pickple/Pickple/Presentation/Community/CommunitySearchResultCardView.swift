//
//  CommunitySearchResultCardView.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 정리는 나중에: 타입 캡슐(아이콘+텍스트+캡슐 배경) 패턴이
//  CommunityPostCardView/PostSummaryCardView/MainHotPostCardView에도 그대로 중복되어 있음.
//  당장은 그 기존 스타일을 그대로 재사용하고, 공용 컴포넌트 추출은 나중에.

import SwiftUI

struct CommunitySearchResultCardView: View {
    let post: PostSummary

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4) {
                    switch post.type {
                    case .text: Image("PickpleText").resizable().frame(width: 16, height: 16)
                    case .forAgainst: Image("PickpleAgainst").resizable().frame(width: 16, height: 16)
                    case .ab: Image("PickpleAB").resizable().frame(width: 16, height: 16)
                    }
                    
                    Text(post.type.displayName)
                        .pickpleTypography(.label)
                        .foregroundStyle(Color.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Capsule().foregroundStyle(Color.black))
                
                    Text(post.title)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.black)
                        .lineLimit(1)
                
                Spacer()

                    
                    HStack(spacing: 16) {
                        HStack(spacing: 8) {
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
                        }
                                                
                        Text(post.createdAt.relativeTimeDescription)
                            .pickpleTypography(.caption)
                            .foregroundStyle(Color.neutral40)
                    }
                    .pickpleTypography(.label)
                    .foregroundStyle(Color.neutral30)
                
            }
            .frame(height: 100)
            .padding(.vertical, 4)
            
            Spacer()
            
            if post.type != .text {
                AsyncImage(url: post.thumbnailUrl) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Image("McokMyPostPicture").resizable().scaledToFill()
                }
                .frame(width: 120, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .clipped()
            }
        }

    }
}

#Preview {
    CommunitySearchResultCardView(
        post: PostSummary(
            id: 1,
            type: .forAgainst,
            category: "패션/잡화",
            title: "나이키 에어포스 흰색으로 살까?",
            description: "데일리로 신을건데 나이키 에어포스 흰색 어때? 흰색 때타고 별로이려나? 검은색은 이미 있어서 이번엔 흰 색도 사보려는데 어떻게 생각해?",
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
