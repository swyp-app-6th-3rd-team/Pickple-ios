//
//  CardView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//
//  TODO: 디자인 확정 후 변경 필요 — AB 유형 두 번째 사진/버튼 라벨은 임시값(전용 디자인 없음)

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
                    cardImage
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    bottomGradient
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .allowsHitTesting(false)

                VStack(alignment: .leading) {
                    HStack(spacing: 4) {
                        Image("PickpleFire")
                            .resizable()
                            .frame(width: 16, height: 16)
                        
                        Text("\(data.participantCount)명 투표중")
                            .pickpleTypography(.body02)
                            .foregroundStyle(Color.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.4))
                    .clipShape(Capsule())
                    .padding(12)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(data.productName)
                                .pickpleTypography(.title02)
                                .foregroundStyle(Color.white)

                            Text(data.concernText)
                                .pickpleTypography(.body02)
                                .foregroundStyle(Color.neutral10)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 22)
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
                .frame(maxWidth: .infinity, alignment: .leading)

                }
            .frame(width: 333, height: 455)

                .contentShape(Rectangle())
                .onTapGesture(perform: onTapBody)
            }
        }

    // AB 픽은 상품 사진 두 장을 상/하로 나눠서 보여준다. 찬반 픽은 대표 사진 한 장 그대로.
    @ViewBuilder
    private var cardImage: some View {
        if data.type == .ab {
            VStack(spacing: 0) {
                productImage(data.imageUrl)
                productImage(data.secondImageUrl)
            }
        } else {
            productImage(data.imageUrl)
        }
    }

    private func productImage(_ url: URL?) -> some View {
        AsyncImage(url: url) { image in
            image.resizable()
        } placeholder: {
            Image("MockAgainstPicture").resizable()
        }
    }

    // 사진 위에 얹는 하단 그라데이션. 디자인 스펙(Figma Fill): Linear, 0%는 #000000 0%(완전 투명),
    // 100%는 #000000 100%(불투명), 이미지 하단에서 152pt 높이만 적용 — 그 위는 원본 사진이 그대로
    // 보이고 하단 152pt 구간에서만 검게 깔려서 그 위에 얹는 흰 글씨가 잘 읽히게 한다.
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
