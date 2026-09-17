//
//  CardView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//
// 투표 버튼의 기본 색상 확인 필요
// 1차 점검 완료 - 9월 12일
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
                    .frame(width: 333, height: 526)
                    .scaledToFill()
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
                            .pickpleTypography(.label_600)
                            .foregroundStyle(Color.white)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    // 캡슐에 .blur()를 바로 걸면 둥근 양 끝이 안쪽으로 침식돼 찌그러져 보인다.
                    // 캡슐을 blur 반경(8)만큼 미리 키워서 블러를 걸고, 원래 크기로 다시
                    // 잘라내면 침식된 가장자리만 잘려나가고 보이는 부분은 멀쩡하게 남는다.
                    .background(
                        Capsule()
                            .foregroundStyle(Color.black.opacity(0.4))
                            .padding(-8)
                            .blur(radius: 8)
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
                                .pickpleTypography(.body02_600)
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

    // AB 픽은 상품 사진 두 장을 상/하로 나눠서 보여준다. 찬반 픽은 대표 사진 한 장 그대로.
    // TODO: CommunityPostCardView에서 겪은 것과 같은 위험 — productImage()의 AsyncImage엔
    // 명시적 frame이 없고 카드 맨 위 .frame(width: 333, height: 526)에만 기대고 있다(특히
    // .ab일 때 두 장을 세로로 쌓는 구조가 그때와 동일). 서버 원본이 리사이징 없이 큰 사진으로
    // 오면 레이아웃이 끌려갈 수 있다. 재현되면 CommunityPostCardView처럼 Color+overlay로 감쌀 것.
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
        PickpleAsyncImage(url: url, targetSize: CGSize(width: 333, height: 526)) { image in
            image.resizable().scaledToFill()
        } placeholder: {
            Image("MockAgainstPicture").resizable().scaledToFill()
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
