//
//  PickpleCardStackView.swift
//  Pickple
//
//  Created by 박윤수 on 8/31/26.
//

import SwiftUI

struct CardStackView: View {
    @ObservedObject var cardStackViewModel: CardStackViewModel
    let onTapCard: (VoteCard) -> Void
    @State private var dragOffset: CGSize = .zero

    private let swipeThreshold: CGFloat = 120

    var body: some View {
        ZStack {
            // index가 배열 순서 = 쌓인 순서라, index 0이 맨 앞(터치 가능한) 카드.
            // zIndex는 뒤집어서 index가 작을수록 위로 그려지게 함.
            ForEach(Array(cardStackViewModel.voteCardData.enumerated()), id: \.element.id) { index, data in
                CardView(
                    data: data,
                    onVote: { side in cardStackViewModel.vote(cardID: data.id, side: side) },
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

    // 맨 앞 카드(0)는 안 기울고, 나머지는 전부 같은 각도로 살짝 기울어짐
    // index == 0일 때 .degrees(dragOffset.width / 20)을 쓰면 드래그하는 만큼 같이 기울어지는 효과
    private func rotation(for index: Int) -> Angle {
        index == 0 ? .zero : .degrees(2.65)
    }

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
                // 애니메이션이 끝난 뒤(completion)에만 실제로 배열에서 제거해서
                // 카드가 사라지는 것과 다음 카드가 앞으로 오는 게 자연스럽게 이어지게 함
                let direction: CGFloat = value.translation.width > 0 ? 1 : -1
                withAnimation(.easeOut(duration: 0.25)) {
                    dragOffset.width = direction * 600
                } completion: {
                    cardStackViewModel.removeTopCard()
                    dragOffset = .zero
                }
            }
    }
}



#Preview {
    CardStackView(cardStackViewModel: CardStackViewModel(), onTapCard: { _ in })
}
