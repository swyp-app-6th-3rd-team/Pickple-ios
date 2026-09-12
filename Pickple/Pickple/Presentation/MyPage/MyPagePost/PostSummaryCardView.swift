//
//  SwiftUIView.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//

import SwiftUI

struct PostSummaryCardView: View {
    let post: PostSummary
    var showsAuthorNickname: Bool = false
    
    var body: some View {
        //MARK: - Image
        VStack(spacing: 8) {
            ZStack (alignment: .topLeading){
                AsyncImage(url: post.thumbnailUrl) { image in
                    image.resizable()
                } placeholder: {
                    Image("McokMyPostPicture").resizable()
                }
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                //MARK: - Badge
                PostTypeBadge(type: post.type)
                    .padding(10)

            }
            
            //MARK: - Title
            HStack {
                VStack(alignment: .leading) {
                    Text(post.category)
                        .pickpleTypography(.caption)
                        .foregroundStyle(Color.neutral50)
                    
                    Text(post.title)
                        .lineLimit(1)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.black)
                }
                Spacer()
            }
            
            //MARK: - Stats
            HStack {
                PostVoteCommentStats(type: post.type, voteCount: post.voteCount, commentCount: post.commentCount)
                    .pickpleTypography(.label)
                    .foregroundStyle(Color.neutral30)

                Spacer()
                
                if showsAuthorNickname, let authorNickname = post.authorNickname {
                    HStack(spacing: 8){
                        HStack(spacing: 2) {
                            Text(authorNickname)
                                .pickpleTypography(.caption)
                                .foregroundStyle(Color.neutral40)

                            if let authorLevel = post.authorLevel {
                                Image("PickpleLevelBadge\(authorLevel)")
                                    .resizable()
                                    .frame(width: 14, height: 14)
                            }
                        }
                        Divider()
                            .frame(height: 12)
                    }
                }
                
                Text(post.createdAt.relativeTimeDescription)
                    .pickpleTypography(.caption)
                    .foregroundStyle(Color.neutral40)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    PostSummaryCardView(
        post: PostSummary(
            id: 1,
            type: .forAgainst,
            category: "전자제품",
            title: "무선 이어폰 살까 말까",
            description: "요즘 유선 이어폰 선 꼬이는게 스트레스인데 무선으로 넘어갈까 고민이에요.",
            thumbnailUrl: nil,
            authorNickname: "픽플닉네임",
            authorLevel: 1,
            authorProfileImageUrl: nil,
            voteCount: 12,
            commentCount: 4,
            createdAt: Date().addingTimeInterval(-60 * 5)
        )
    )
    .frame(width: 160, height: 253)
    .padding()
}
