//
//  PickpleCardStackView.swift
//  Pickple
//
//  Created by 박윤수 on 8/31/26.
// 1차 점검 완료 - 9월 20일
// 디자인 요구 반영했지만 자세한 수치 느낌은 조율해야함

import SwiftUI

struct CardStackView: View {
    let cardStackViewModel: CardStackViewModel
    let onTapCard: (VoteCard) -> Void
    var onVoteCompleted: () -> Void = {}
    @State private var dragOffset: CGSize = .zero

    private let swipeThreshold: CGFloat = 120

    var body: some View {
        ZStack {
            // index가 배열 순서 = 쌓인 순서라, index 0이 맨 앞(터치 가능한) 카드.
            // zIndex는 뒤집어서 index가 작을수록 위로 그려지게 함.
            ForEach(Array(cardStackViewModel.voteCardData.enumerated()), id: \.element.id) { index, data in
                CardView(
                    data: data,
                    myProfileImageUrl: cardStackViewModel.myProfileImageUrl,
                    onVote: { side in
                        Task {
                            await cardStackViewModel.vote(cardID: data.id, side: side)
                            onVoteCompleted()
                        }
                    },
                    onTapBody: { onTapCard(data) }
                )
                    .zIndex(Double(-index))
                    .rotationEffect(rotation(for: index))
                    .offset(index == 0 ? dragOffset : .zero)
                    // count가 바뀔 때(카드 제거)만 애니메이션 걸어서, 맨 앞으로 올라온 카드의
                    // 기울기가 rotation(for: 0)의 .zero로 스프링 애니메이션과 함께 자동으로 펴지게 함.
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: cardStackViewModel.voteCardData.count)
                    // 제스처는 카드마다 항상 붙이되, isTop이 아니면 내부에서 아무것도 안 하게 함
                    // (.gesture()에 조건부로 nil을 못 넘겨서 이렇게 우회).
                    .gesture(dragGesture(isTop: index == 0))
            }
        }
    }

    // 맨 앞 카드(0)는 끄는 방향·거리에 비례해서 기운다(틴더 스타일) — maxDragRotationDegrees에서 클램프.
    // 뒤에 쌓인 카드들은 전부 restingRotationDegrees로 통일.
    // 바로 다음 카드(1)만 앞 카드를 얼마나 드래그했는지에 비례해서 restingRotationDegrees → 0도로
    // 실시간으로 펴지게 해서, 카드가 넘어갈 때 각도가 툭 튀지 않고 자연스럽게 이어진다.
    // swipeThreshold(스와이프 확정 거리)보다 훨씬 긴 rotationUnwindDistance를 기준으로 삼아서
    // 손을 떼는 시점(threshold 근처)에는 아직 다 안 펴진 상태로, 더 끝까지 끌어야 완전히 펴지게 완화했다.
    private func rotation(for index: Int) -> Angle {
        switch index {
        case 0:
            let dragDegrees = Double(dragOffset.width / dragRotationDivisor)
            return .degrees(min(max(dragDegrees, -maxDragRotationDegrees), maxDragRotationDegrees))
        case 1:
            let progress = min(abs(dragOffset.width) / rotationUnwindDistance, 1)
            return .degrees(restingRotationDegrees * (1 - progress))
        default:
            return .degrees(restingRotationDegrees)
        }
    }

    private let restingRotationDegrees: Double = -5.0
    private let rotationUnwindDistance: CGFloat = 320
    private let dragRotationDivisor: CGFloat = 20
    private let maxDragRotationDegrees: Double = 15

    private func dragGesture(isTop: Bool) -> some Gesture {
        DragGesture()
            .onChanged { value in
                guard isTop else { return }
                dragOffset.width = value.translation.width   // 세로는 무시, 좌우로만 따라 움직임
            }
            .onEnded { value in
                guard isTop else { return }
                // 임계값 못 넘으면 스프링으로 제자리 복귀
                guard abs(value.translation.width) > swipeThreshold else {
                    withAnimation(.spring()) { dragOffset = .zero }
                    return
                }
                // 넘겼으면 그 방향으로 화면 밖까지 날려보내고,
                // 애니메이션이 끝난 뒤(completion)에만 실제로 맨 뒤로 옮겨서
                // 카드가 사라지는 것과 다음 카드가 앞으로 오는 게 자연스럽게 이어지게 함
                let direction: CGFloat = value.translation.width > 0 ? 1 : -1
                withAnimation(.easeOut(duration: 0.25)) {
                    dragOffset.width = direction * 600
                } completion: {
                    cardStackViewModel.moveTopCardToBack()
                    dragOffset = .zero
                }
            }
    }
}



#Preview {
    CardStackView(cardStackViewModel: CardStackViewModel(), onTapCard: { _ in })
}
