//
//  MainHotPostCardView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료 - 9월 12일
// 투표 수, 댓글 수 폰트 미지정


import SwiftUI

struct MainHotPostCardView: View {
    let post: PostSummary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                AsyncImage(url: post.thumbnailUrl) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Image("McokMyPostPicture").resizable().scaledToFill()
                }
                .frame(width: 160, height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .clipped()
                
                PostTypeBadge(type: post.type, iconSize: 16, typography: .label, horizontalPadding: 10)
                    .padding(10)
            }
            VStack(spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(post.category)
                            .pickpleTypography(.caption)
                            .foregroundStyle(Color.neutral50)
                        
                        Text(post.title)
                            .pickpleTypography(.body01)
                            .foregroundStyle(Color.black)
                            .lineLimit(1)
                    }
                    Spacer()
                }
                
                HStack(spacing: 8) {
                    PostVoteCommentStats(type: post.type, voteCount: post.voteCount, commentCount: post.commentCount)
                        .pickpleTypography(.caption) //폰트 미지정
                        .foregroundStyle(Color.neutral20)
                    
                    Spacer()
                    
                    Text(post.createdAt.relativeTimeDescription)
                        .lineLimit(1)
                        .pickpleTypography(.caption)
                        .foregroundStyle(Color.neutral20)
                }
                
                .padding(.horizontal, 2)
            }
        }
        .frame(width: 160) //하단 정보들의 넓이를 사진 넓이와 맞춤
    }
}

#Preview {
    MainHotPostCardView(
        post: PostSummary(
            id: 1,
            type: .forAgainst,
            category: "패션/잡화",
            title: "나이키 에어포스 흰색으로 살까?",
            description: "",
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
