//
//  CommunityPostCardView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료 - 9월 12일
// 미지정 폰트 확인 필요
// 분리 바 확인 필요(리소스 및 색상)

import SwiftUI

struct CommunityPostCardView: View {
    let post: PostSummary
    
    var body: some View {
        VStack(spacing: 8) {
            // 일반 게시글은 서버가 애초에 thumbnailUrl을 안 준다 — 그런데도
            // AsyncImage의 placeholder가 목업 사진을 채워서 없는 이미지가 있는 것처럼 보였다.
            // 유형 배지는 이미지 유무와 무관하게 항상 보여야 하므로 이미지만 조건부로 뺀다.
            if post.type == .text {
                PostTypeBadge(type: post.type)
            } else {
                ZStack(alignment: .topLeading) {
                    AsyncImage(url: post.thumbnailUrl) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Image("McokMyPostPicture").resizable().scaledToFill()
                    }
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .clipped()

                    PostTypeBadge(type: post.type)
                        .padding(10)
                }
            }
            
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(post.title)
                        .pickpleTypography(.title02)
                        .foregroundStyle(Color.black)
                    
                    Text(post.description)
                        .pickpleTypography(.body02)
                        .foregroundStyle(Color.neutral40)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 0) {
                HStack {
                    PostVoteCommentStats(type: post.type, voteCount: post.voteCount, commentCount: post.commentCount)
                        .pickpleTypography(.label)
                        .foregroundStyle(Color.neutral30)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        if let authorNickname = post.authorNickname {
                            HStack(spacing: 2) {
                                Text(authorNickname)
                                    .pickpleTypography(.caption) //폰트 미지정
                                    .foregroundStyle(Color.neutral40)
                                
                                if let authorLevel = post.authorLevel {
                                    Image("PickpleLevelBadge\(authorLevel)")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                            }
                            
                            Divider() //실제 디자인과 맞는지 확인 필요
                                .frame(height: 12)
                        }
                        
                        Text(post.createdAt.relativeTimeDescription)
                            .pickpleTypography(.caption)// 폰트 미지정
                            .foregroundStyle(Color.neutral40)
                    }
                }
                .padding(.vertical, 16)
                Divider()
            }
            }
        }
    }
}

#Preview {
    CommunityPostCardView(
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
