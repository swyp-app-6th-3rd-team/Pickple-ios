//
//  CardView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//
// 1차 점검 완료 - 9월 12일
// 여기도 블러처리 어케해야하누

import SwiftUI

struct CardView: View {
    let data: VoteCard
    let myProfileImageUrl: URL?
    let onVote: (PostDetailVoteSide) -> Void
    let onTapBody: () -> Void
    
    private var firstLabel: String {
        data.type == .forAgainst ? MainStrings.voteSideFor : "A"
    }
    
    private var secondLabel: String {
        data.type == .forAgainst ? MainStrings.voteSideAgainst : "B"
    }
    
    var body: some View {
        VStack(spacing: 22) {
            ZStack(alignment: .topLeading) {
                if data.type == .ab {
                    VStack(spacing: 0) {
                        image(data.imageUrl)
                        image(data.secondImageUrl)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.08), radius: 12)
                } else {
                    image(data.imageUrl)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.black.opacity(0.08), radius: 12)
                }
                bottomGradient
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .allowsHitTesting(false)
                
                VStack(alignment: .leading) {
                    HStack(spacing: 4) {
                        Image("PickpleFire")
                            .resizable()
                            .frame(width: 16, height: 16)
                        
                        Text("\(data.participantCount)명 투표중")
                            .pickpleTypography(.label_600)
                            .foregroundStyle(Color.white)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .foregroundStyle(Color.black.opacity(0.4))
                            .padding(-8)
                        //.blur(radius: 8)
                    )
                    .clipShape(Capsule())
                    .padding(16)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(data.productName)
                                .pickpleTypography(.title02_600)
                                .foregroundStyle(Color.white)
                            
                            Text(data.concernText)
                                .pickpleTypography(.body02_400)
                                .foregroundStyle(Color.neutral10)
                                .lineLimit(1)
                        }
                        .padding(.horizontal, 20)
                        .contentShape(Rectangle())
                        .onTapGesture(perform: onTapBody)
                        
                        PostDetailVoteButtons(
                            firstLabel: firstLabel,
                            secondLabel: secondLabel,
                            votedSide: data.votedSide,
                            firstPercentage: data.firstPercentage ?? 0,
                            secondPercentage: data.secondPercentage ?? 0,
                            myProfileImageUrl: myProfileImageUrl,
                            onVote: onVote
                        )
                        .frame(height:48)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        
                    }
                }
                
            }
            .frame(width: 333, height: 526) //카드 뷰의 크기는 고정
            .contentShape(Rectangle())
            .onTapGesture(perform: onTapBody)
        }
    }
    
    //MARK: - Image
    private func image(_ url: URL?) -> some View {
        if data.type == .forAgainst {
            PickpleAsyncImage(url: url, targetSize: CGSize(width: 333, height: 526)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 333, height: 526)
                    .clipped()
            } placeholder: {
                Color.navy10
            }
        } else {
            PickpleAsyncImage(url: url, targetSize: CGSize(width: 333, height: 263)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 333, height: 263)
                    .clipped()
            } placeholder: {
                Color.navy10
            }
        }
    }
    
    //MARK: - bottomGradient
    private var bottomGradient: some View {
        VStack(spacing: 0) {
            Spacer()
            LinearGradient(
                stops: [
                    .init(color: Color.black.opacity(0), location: 0),
                    .init(color: Color.black.opacity(1), location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 152)
        }
    }
    
}

#Preview("찬반 픽") {
    CardView(
        data: VoteCard(
            id: 1,
            type: .forAgainst,
            productName: "무선 이어폰",
            concernText: "이거 살까 말까 고민이에요",
            imageUrl: nil,
            secondImageUrl: nil,
            participantCount: 1234,
            firstOptionId: 0,
            secondOptionId: 1,
            firstPercentage: nil,
            secondPercentage: nil
        ),
        myProfileImageUrl: nil,
        onVote: { _ in },
        onTapBody: {}
    )
}

#Preview("AB 픽") {
    CardView(
        data: VoteCard(
            id: 2,
            type: .ab,
            productName: "노트북 A vs B",
            concernText: "둘 중 뭐가 나을까요",
            imageUrl: nil,
            secondImageUrl: nil,
            participantCount: 234,
            firstOptionId: 0,
            secondOptionId: 1,
            firstPercentage: nil,
            secondPercentage: nil
        ),
        myProfileImageUrl: nil,
        onVote: { _ in },
        onTapBody: {}
    )
}

#Preview("AB 픽 - 투표 완료") {
    CardView(
        data: VoteCard(
            id: 3,
            type: .ab,
            productName: "노트북 A vs B",
            concernText: "둘 중 뭐가 나을까요",
            imageUrl: nil,
            secondImageUrl: nil,
            participantCount: 234,
            firstOptionId: 0,
            secondOptionId: 1,
            firstPercentage: 62,
            secondPercentage: 38,
            votedSide: .first
        ),
        myProfileImageUrl: nil,
        onVote: { _ in },
        onTapBody: {}
    )
}
