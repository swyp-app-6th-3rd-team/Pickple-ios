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
    let onVote: (VoteCardSide) -> Void
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
                    AsyncImage(url: data.imageUrl) { image in
                        image.resizable()
                    } placeholder: {
                        Image("MockAgainstPicture").resizable()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
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
                        
                        if data.isVoted {
                            VoteCardGaugeBar(
                                firstLabel: firstLabel,
                                secondLabel: secondLabel,
                                firstPercentage: data.firstPercentage ?? 0,
                                secondPercentage: data.secondPercentage ?? 0
                            )
                            .padding(.horizontal, 20)
                        } else {
                            
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                }
            .frame(width: 333, height: 455)

                .contentShape(Rectangle())
                .onTapGesture(perform: onTapBody)
            }
        }
    }


// 투표 완료 후 두 항목의 비율을 하나의 막대로 채워서 보여준다.
private struct VoteCardGaugeBar: View {
    let firstLabel: String
    let secondLabel: String
    let firstPercentage: Int
    let secondPercentage: Int

    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 2) {
                gaugeSegment(label: firstLabel, percentage: firstPercentage)
                    .frame(width: proxy.size.width * CGFloat(firstPercentage) / 100)

                gaugeSegment(label: secondLabel, percentage: secondPercentage)
                    .frame(width: proxy.size.width * CGFloat(secondPercentage) / 100)
            }
        }
        .frame(height: 48)
    }

    private func gaugeSegment(label: String, percentage: Int) -> some View {
        HStack(spacing: 4) {
            Text(label)
            Text("\(percentage)%")
        }
        .pickpleTypography(.body02)
        .foregroundStyle(Color.white)
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(Color.navy60)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    CardView(
        data: VoteCard(
            id: 1,
            type: .forAgainst,
            productName: "무선 이어폰",
            concernText: "이거 살까 말까 고민이에요",
            imageUrl: nil,
            secondImageUrl: nil,
            participantCount: 1234,
            firstPercentage: nil,
            secondPercentage: nil
        ),
        onVote: { _ in },
        onTapBody: {}
    )
}
