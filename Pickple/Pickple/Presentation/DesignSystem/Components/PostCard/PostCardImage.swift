//
//  PostCardImage.swift
//  Pickple
//
//  Created by 박윤수 on 9/12/26.
//
// 1차 점검 완료 - 9월 13일


import SwiftUI

struct PostCardImage: View {
    var url: URL?
    var type: VoteType
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            AsyncImage(url: url) { image in
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
                    // 도형에 .blur()를 바로 걸면 모서리가 안쪽으로 침식돼 찌그러져 보인다.
                    // 도형을 blur 반경(4)만큼 미리 키워서 블러를 걸고, 원래 크기로 다시
                    // 잘라내면 침식된 가장자리만 잘려나가고 보이는 부분은 멀쩡하게 남는다.
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
                    // 도형에 .blur()를 바로 걸면 모서리가 안쪽으로 침식돼 찌그러져 보인다.
                    // 도형을 blur 반경(4)만큼 미리 키워서 블러를 걸고, 원래 크기로 다시
                    // 잘라내면 침식된 가장자리만 잘려나가고 보이는 부분은 멀쩡하게 남는다.
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
            case .ab:
                Image("PickpleAB")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(4)
                    // 도형에 .blur()를 바로 걸면 모서리가 안쪽으로 침식돼 찌그러져 보인다.
                    // 도형을 blur 반경(4)만큼 미리 키워서 블러를 걸고, 원래 크기로 다시
                    // 잘라내면 침식된 가장자리만 잘려나가고 보이는 부분은 멀쩡하게 남는다.
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
            }
                
            
        }
    }
}

#Preview {
    if let url = URL(string: "https://picsum.photos/72") {
        PostCardImage(url: url, type: .forAgainst)
    }
}
