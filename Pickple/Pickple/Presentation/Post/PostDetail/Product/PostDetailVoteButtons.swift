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
    let onVote: (PostDetailVoteSide) -> Void

    private var isVoted: Bool { votedSide != nil }

    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: isVoted ? 0 : 8) {
                PostDetailVoteSegment(
                    label: firstLabel,
                    percentage: firstPercentage,
                    isVoted: isVoted,
                    isWinning: firstPercentage >= secondPercentage,
                    corner: .leading,
                    action: { onVote(.first) }
                )
                .frame(width: segmentWidth(totalWidth: proxy.size.width, percentage: firstPercentage))

                PostDetailVoteSegment(
                    label: secondLabel,
                    percentage: secondPercentage,
                    isVoted: isVoted,
                    isWinning: secondPercentage >= firstPercentage,
                    corner: .trailing,
                    action: { onVote(.second) }
                )
                .frame(width: segmentWidth(totalWidth: proxy.size.width, percentage: secondPercentage))
            }
        }
        .frame(height: 52)
        .animation(.easeInOut(duration: 0.35), value: votedSide)
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
    let percentage: Int
    let isVoted: Bool
    let isWinning: Bool
    let corner: PostDetailVoteSegmentCorner
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(isVoted ? "\(label) \(percentage)%" : label)
                .pickpleTypography(.body01)
                .foregroundStyle(textColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(backgroundColor)
        }
        .disabled(isVoted)
        .clipShape(shape)
    }

    private var textColor: Color {
        guard isVoted else { return Color.neutral70 }
        return isWinning ? Color.white : Color.neutral70
    }

    private var backgroundColor: Color {
        guard isVoted else { return Color.neutral10 }
        return isWinning ? Color.neutral100 : Color.neutral10
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

#Preview {
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
                    onVote: { votedSide = $0 }
                )
            }
            .padding()
        }
    }
    return PreviewWrapper()
}
