//
//  PostCardImage.swift
//  Pickple
//
//  Created by 박윤수 on 9/12/26.
//
// 1차 점검 완료 - 9월 13일
// 블러처리를 어케해야하누...

import SwiftUI

struct PostCardImage: View {
    var url: URL?
    var type: VoteType
    private var iconName: String {
        switch type {
        case .forAgainst: return "PickpleAgainst"
        case .ab: return "PickpleAB"
        case .text: return "PickpleText"
        }
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            PickpleAsyncImage(
                url: url,
                targetSize: CGSize(width: 72, height: 72)
            ) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.navy10
            }
            .frame(width: 72, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .clipped()
            
            switch type {
            case .text, .forAgainst, .ab: PostCardTypeIcon(icon: iconName)
            }
        }
    }
}

struct PostCardTypeIcon: View {
    let icon: String
    
    var body: some View {
        Image(icon)
            .resizable()
            .frame(width: 16, height: 16)
            .padding(4)
            .background(
                UnevenRoundedRectangle(
                    topLeadingRadius: 8,
                    bottomTrailingRadius: 8
                )
                .fill(Color.black.opacity(0.4))
                //blur(radius: 4)
                    .frame(width: 24, height: 24)
            )
    }
}

#Preview {
    if let url = URL(string: "https://picsum.photos/72") {
        PostCardImage(url: url, type: .forAgainst)
    }
}
