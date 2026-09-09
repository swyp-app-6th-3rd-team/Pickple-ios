//
//  PostDetailVoteButtons.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

// 투표 전엔 선택 버튼 두 개, 투표 후엔 두 버튼이 하나로 합쳐지며
// 사자/말자 비율만큼 폭이 채워진 결과 바로 애니메이션과 함께 바뀐다.
struct PostDetailVoteButtons: View {
    let firstLabel: String
    let secondLabel: String
    let votedSide: PostDetailVoteSide?
    let firstPercentage: Int
    let secondPercentage: Int
    let myProfileImageUrl: URL?
    let onVote: (PostDetailVoteSide) -> Void

    private var isVoted: Bool { votedSide != nil }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                HStack(spacing: isVoted ? 0 : 8) {
                    PostDetailVoteSegment(
                        label: firstLabel,
                        isVoted: isVoted,
                        isSelected: votedSide == .first,
                        corner: .leading,
                        action: { onVote(.first) }
                    )
                    .frame(width: segmentWidth(totalWidth: proxy.size.width, percentage: firstPercentage))

                    PostDetailVoteSegment(
                        label: secondLabel,
                        isVoted: isVoted,
                        isSelected: votedSide == .second,
                        corner: .trailing,
                        action: { onVote(.second) }
                    )
                    .frame(width: segmentWidth(totalWidth: proxy.size.width, percentage: secondPercentage))
                }

                // 양쪽 라벨(선택 쪽은 아이콘까지)을 세그먼트 폭과 무관하게 항상 바 전체의
                // 좌/우 벽에 붙는 오버레이로 그린다 — 세그먼트가 아무리 좁아져도 안 잘린다.
                // if/else-if로 오버레이 자체를 넣었다 뺐다 하면 애니메이션 중 잠깐 사라지는
                // 문제가 있었어서, ZStack 하나를 항상 그 자리에 유지하고 opacity와 아이콘
                // 유무만 바꾼다.
                ZStack {
                    HStack(spacing: 4) {
                        if votedSide == .first { profileIcon }
                        resultLabel(firstLabel, percentage: firstPercentage, isSelected: votedSide == .first)
                        Spacer(minLength: 0)
                    }
                    .padding(.leading, 12)

                    HStack(spacing: 4) {
                        Spacer(minLength: 0)
                        resultLabel(secondLabel, percentage: secondPercentage, isSelected: votedSide == .second)
                        if votedSide == .second { profileIcon }
                    }
                    .padding(.trailing, 12)
                }
                .opacity(isVoted ? 1 : 0)
                .allowsHitTesting(false)
            }
        }
        .frame(height: 52)
        .animation(.easeInOut(duration: 0.35), value: votedSide)
    }

    private func resultLabel(_ label: String, percentage: Int, isSelected: Bool) -> some View {
        Text("\(label) \(percentage)%")
            .pickpleTypography(.body01)
            .foregroundStyle(isSelected ? Color.white : Color.neutral70)
    }

    private var profileIcon: some View {
        AsyncImage(url: myProfileImageUrl) { image in
            image.resizable().scaledToFill()
        } placeholder: {
            ZStack {
                Color.white
                Image("PickpleCharacter")
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: 28, height: 28)
        .clipShape(Circle())
    }

    private func segmentWidth(totalWidth: CGFloat, percentage: Int) -> CGFloat {
        isVoted ? totalWidth * CGFloat(percentage) / 100 : (totalWidth - 8) / 2
    }
}

private enum PostDetailVoteSegmentCorner {
    case leading
    case trailing
}

private struct PostDetailVoteSegment: View {
    let label: String
    let isVoted: Bool
    let isSelected: Bool
    let corner: PostDetailVoteSegmentCorner
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            // 투표 후엔 라벨(선택 쪽은 아이콘까지)을 부모(PostDetailVoteButtons)가 세그먼트
            // 폭과 무관한 오버레이로 그리므로, 여기선 투표 전 라벨만 그린다.
            // 바탕을 Color.clear로 깔아야 한다 — EmptyView는 .frame(maxWidth: .infinity)를
            // 줘도 크기가 0으로 붕괴해서 배경(.background)까지 안 보이게 된다.
            Color.clear
                .overlay {
                    if !isVoted {
                        Text(label)
                            .pickpleTypography(.body01)
                            .foregroundStyle(Color.neutral70)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(backgroundColor)
        }
        .disabled(isVoted)
        .clipShape(shape)
    }

    private var backgroundColor: Color {
        guard isVoted else { return Color.neutral10 }
        return isSelected ? Color.neutral100 : Color.neutral10
    }

    // 투표 전엔 두 버튼이 각자 독립된 알약 모양이고, 투표 후엔 하나의 바로 합쳐지므로
    // 서로 맞닿는 안쪽 모서리는 각지게, 바깥쪽 모서리만 둥글게 그린다.
    private var shape: UnevenRoundedRectangle {
        guard isVoted else {
            return UnevenRoundedRectangle(topLeadingRadius: 8, bottomLeadingRadius: 8, bottomTrailingRadius: 8, topTrailingRadius: 8)
        }
        switch corner {
        case .leading:
            return UnevenRoundedRectangle(topLeadingRadius: 8, bottomLeadingRadius: 8, bottomTrailingRadius: 0, topTrailingRadius: 0)
        case .trailing:
            return UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 8, topTrailingRadius: 8)
        }
    }
}

#Preview("탭해서 투표") {
    struct PreviewWrapper: View {
        @State private var votedSide: PostDetailVoteSide?

        var body: some View {
            VStack(spacing: 20) {
                PostDetailVoteButtons(
                    firstLabel: "사자",
                    secondLabel: "말자",
                    votedSide: votedSide,
                    firstPercentage: 70,
                    secondPercentage: 30,
                    myProfileImageUrl: nil,
                    onVote: { votedSide = $0 }
                )
            }
            .padding()
        }
    }
    return PreviewWrapper()
}

// 좁은 쪽 라벨이 잘리지 않는지 확인하기 위한 극단적 비율 케이스.
#Preview("좁은 영역 - 1번 선택 95/5") {
    PostDetailVoteButtons(
        firstLabel: "사자",
        secondLabel: "말자",
        votedSide: .first,
        firstPercentage: 95,
        secondPercentage: 5,
        myProfileImageUrl: nil,
        onVote: { _ in }
    )
    .padding()
}

#Preview("좁은 영역 - 2번 선택 5/95") {
    PostDetailVoteButtons(
        firstLabel: "사자",
        secondLabel: "말자",
        votedSide: .second,
        firstPercentage: 5,
        secondPercentage: 95,
        myProfileImageUrl: nil,
        onVote: { _ in }
    )
    .padding()
}
