//
//  PostCardImage.swift
//  Pickple
//
//  Created by 박윤수 on 9/12/26.
//
// 1차 점검 완료 - 9월 13일
// 블러 처리방법 찾는중 - 어케하노;;


import SwiftUI

struct PostCardImage: View {
    var url: URL?
    var type: VoteType
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            PickpleAsyncImage(url: url, targetSize: CGSize(width: 72, height: 72)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Image("McokMyPostPicture")
                    .resizable()
                    .scaledToFill()
            }
            .frame(width: 72, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .clipped()
            
            switch type {
            case .text:
                Image("PickpleText")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(4)
                    .background(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 8,
                            bottomTrailingRadius: 8
                        )
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.black.opacity(0.4))
                        .padding(-4)
                        .blur(radius: 4)
                    )
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 8,
                            bottomTrailingRadius: 8
                        )
                    )
            case .forAgainst:
                Image("PickpleAgainst")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(4)
                    .background(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 8,
                            bottomTrailingRadius: 8
                        )
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.black.opacity(0.4))
                    )

            case .ab:
                Image("PickpleAB")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(4)

                    .background(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 8,
                            bottomTrailingRadius: 8
                        )
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.black.opacity(0.4))
                    )
            }
        }
    }
}

#Preview {
    if let url = URL(string: "https://picsum.photos/72") {
        PostCardImage(url: url, type: .forAgainst)
    }
}
