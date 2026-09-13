//
//  PostCardImage.swift
//  Pickple
//
//  Created by 박윤수 on 9/12/26.
//

import SwiftUI

struct PostCardImage: View {
    var url: URL?
    var type: VoteType

    var body: some View {
        ZStack(alignment: .topLeading) {
            AsyncImage(url: url) { image in
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
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.black.opacity(0.4))

                switch type {
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
}

#Preview {
    if let url = URL(string: "https://picsum.photos/72") {
        PostCardImage(url: url, type: .forAgainst)
    }
}
