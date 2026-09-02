//
//  SwiftUIView.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//

import SwiftUI

struct PostSummaryCardView: View {
    let post: PostSummary
    
    var body: some View {
        //MARK: - Image
        VStack(spacing: 8) {
            ZStack (alignment: .topLeading){
                Image(post.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity) //Fixed
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                //MARK: - Badge
                HStack {
                    switch post.type {
                    case .text: Image("PickpleText").resizable().frame(width: 16, height: 16)
                    case .forAgainst: Image("PickpleAgainst").resizable().frame(width: 16, height: 16)
                    case .compare: Image("PickpleAB").resizable().frame(width: 16, height: 16)
                    }

                    Text(post.type.displayName)
                        .pickpleTypography(.label)
                        .foregroundStyle(Color.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .foregroundStyle(Color.black)
                )
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
                HStack(spacing: 12) {
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
                .pickpleTypography(.label)
                .foregroundStyle(Color.neutral30)
                
                Spacer()
                
                Text(post.createdAt.relativeTimeDescription)
                    .pickpleTypography(.caption)
                    .foregroundStyle(Color.neutral40)
            }
            
        }
        .frame(maxWidth: .infinity)
    }
}
