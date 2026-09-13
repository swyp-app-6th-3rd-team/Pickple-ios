//
//  PostDetailVoteButtons.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료 - 9월 13일

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
            let totalWidth = proxy.size.width
            let firstWidth = segmentWidth(totalWidth: totalWidth, percentage: firstPercentage)
            let secondWidth = segmentWidth(totalWidth: totalWidth, percentage: secondPercentage)
            // 라벨이 자기 세그먼트 폭을 넘어 반대쪽 배경 위에 걸치는지는 실제 텍스트 폭을
            // 알아야 판단할 수 있다. GeometryReader로 렌더링 결과를 측정해 @State에
            // 반영하는 방식은 SwiftUI 렌더링 타이밍에 따라 결과가 들쭉날쭉했어서,
            // 렌더링 결과를 기다리지 않고 같은 폰트로 미리 동기적으로 계산한다.
            let firstTextWidth = Self.textWidth("\(firstLabel) \(firstPercentage)%")
            let secondTextWidth = Self.textWidth("\(secondLabel) \(secondPercentage)%")

            // 두 라벨이 같은 경계선(boundaryX) 하나를 공유한다 — 그 왼쪽은 1번 세그먼트
            // 색, 오른쪽은 2번 세그먼트 색이다. 라벨이 어느 벽에 붙어있든 이 기준 하나로
            // 계산하면 라벨별로 "내 색/반대 색"을 따로 뒤집어 챙길 필요가 없다.
            let boundaryX = firstWidth
            let firstColor: Color = votedSide == .first ? .white : .neutral70
            let secondColor: Color = votedSide == .second ? .white : .neutral70
            // 라벨은 벽에서 12pt 떨어진 지점에서 시작하지만, 선택된 쪽(아이콘이 붙는 쪽)은
            // 아이콘(28)+간격(4)만큼 더 안쪽에서 시작한다.
            let firstLabelStartX: CGFloat = votedSide == .first ? 44 : 12
            let secondLabelStartX = totalWidth - (votedSide == .second ? 44 : 12) - secondTextWidth

            ZStack {
                HStack(spacing: isVoted ? 0 : 8) {
                    PostDetailVoteSegment(
                        label: firstLabel,
                        isVoted: isVoted,
                        isSelected: votedSide == .first,
                        corner: .leading,
                        isFullWidth: firstPercentage >= 100,
                        action: { onVote(.first) }
                    )
                    .frame(width: firstWidth)

                    PostDetailVoteSegment(
                        label: secondLabel,
                        isVoted: isVoted,
                        isSelected: votedSide == .second,
                        corner: .trailing,
                        isFullWidth: secondPercentage >= 100,
                        action: { onVote(.second) }
                    )
                    .frame(width: secondWidth)
                }

                // 양쪽 라벨(선택 쪽은 아이콘까지)을 세그먼트 폭과 무관하게 항상 바 전체의
                // 좌/우 벽에 붙는 오버레이로 그린다 — 세그먼트가 아무리 좁아져도 안 잘린다.
                // if/else-if로 오버레이 자체를 넣었다 뺐다 하면 애니메이션 중 잠깐 사라지는
                // 문제가 있었어서, ZStack 하나를 항상 그 자리에 유지하고 opacity와 아이콘
                // 유무만 바꾼다.
                ZStack {
                    HStack(spacing: 4) {
                        if votedSide == .first { profileIcon }
                        splitLabel(
                            "\(firstLabel) \(firstPercentage)%",
                            measuredWidth: firstTextWidth,
                            labelStartX: firstLabelStartX,
                            boundaryX: boundaryX,
                            beforeColor: firstColor,
                            afterColor: secondColor
                        )
                        Spacer(minLength: 0)
                    }
                    .padding(.leading, 12)

                    HStack(spacing: 4) {
                        Spacer(minLength: 0)
                        splitLabel(
                            "\(secondLabel) \(secondPercentage)%",
                            measuredWidth: secondTextWidth,
                            labelStartX: secondLabelStartX,
                            boundaryX: boundaryX,
                            beforeColor: firstColor,
                            afterColor: secondColor
                        )
                        if votedSide == .second { profileIcon }
                    }
                    .padding(.trailing, 12)
                }
                .opacity(isVoted ? 1 : 0)
                .allowsHitTesting(false)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: votedSide)
    }

    // 실제 SwiftUI 렌더링 결과를 기다리지 않고, 같은 폰트로 미리 텍스트 폭을 계산한다.
    private static func textWidth(_ text: String) -> CGFloat {
        let typography = PickpleTypography.body01
        let attributes: [NSAttributedString.Key: Any] = [
            .font: typography.uiFont,
            .kern: typography.tracking
        ]
        return ceil((text as NSString).size(withAttributes: attributes).width)
    }

    // 라벨이 boundaryX를 넘어가면, 넘어간 부분은 그 자리에 실제로 깔린 반대쪽 배경에
    // 맞는 색이어야 한다. 경계 지점에 하드 스톱 그러데이션을 줘서 그 지점 기준으로
    // 글자 색이 뚝 끊기게 한다 — beforeColor/afterColor는 두 라벨이 공유하는 값이라
    // 라벨마다 "내 색/반대 색"을 따로 뒤집을 필요가 없다.
    private func splitLabel(
        _ text: String,
        measuredWidth: CGFloat,
        labelStartX: CGFloat,
        boundaryX: CGFloat,
        beforeColor: Color,
        afterColor: Color
    ) -> some View {
        let fraction = measuredWidth > 0 ? min(max((boundaryX - labelStartX) / measuredWidth, 0), 1) : 0

        return Text(text)
            .pickpleTypography(.body01)
            .foregroundStyle(
                LinearGradient(
                    stops: [
                        .init(color: beforeColor, location: fraction),
                        .init(color: beforeColor, location: fraction),
                        .init(color: afterColor, location: fraction),
                        .init(color: afterColor, location: 1)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
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
    // 반대쪽이 0%라 이 세그먼트 혼자 바 전체를 차지할 때 — 원래 "서로 맞닿는 안쪽 모서리"였던
    // 게 이제는 바의 진짜 바깥쪽 끝이라, 각지게 두면 안 되고 둥글게 처리해야 한다.
    let isFullWidth: Bool
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
        // neutral15 = #F1F1F5
        guard isVoted else { return Color.neutral15 }
        return isSelected ? Color.neutral100 : Color.neutral15
    }

    // 투표 전엔 두 버튼이 각자 독립된 알약 모양이고, 투표 후엔 하나의 바로 합쳐지므로
    // 서로 맞닿는 안쪽 모서리는 각지게, 바깥쪽 모서리만 둥글게 그린다.
    private var shape: UnevenRoundedRectangle {
        guard isVoted, !isFullWidth else {
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
                .frame(height: 58)
                .border(Color.black)
            }
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
    .frame(height: 58)
    .border(Color.black)
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
    .frame(height: 58)
    .border(Color.black)
}
