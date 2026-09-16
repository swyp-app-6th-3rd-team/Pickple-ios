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
    // 카드별 오프셋을 index가 아니라 card.id로 추적한다 — 왼쪽 스와이프(뒤로가기)로 데이터
    // 순서가 바뀔 때, 방금 뒤로 밀려난 카드(예전엔 index 0 → 1)의 오프셋이 index 기준
    // 조건부(.zero)라 즉시 리셋되면서 스택 안으로 순간이동하듯 "톡" 튀는 문제가 있었다.
    // id로 추적하면 그 카드는 계속 자기 오프셋(-600)을 유지하다가, 아래에서 명시적으로
    // 0으로 애니메이션해줘야만 움직인다.
    @State private var cardOffsets: [Int: CGSize] = [:]
    // 왼쪽으로 끄는 중에는 "이전 카드"를 오른쪽 화면 밖에서부터 손가락을 따라 끌고 들어오는
    // 식으로 보여준다. 그 카드는 배열상 맨 뒤(zIndex가 가장 낮음)라 그냥 두면 다른 카드들에
    // 가려지므로, 끌려오는 동안만 zIndex를 맨 위로 올려서 다른 카드를 덮으며 들어오게 한다.
    @State private var pulledInCardID: Int? = nil

    private let swipeThreshold: CGFloat = 120
    private let offscreenOffset: CGFloat = 600
    // 기존 0.25초 duration은 offscreenOffset(600)을 그 시간에 주파하는 속도였다 — 남은 거리가
    // 손을 뗀 위치에 따라 달라지므로, duration을 고정하는 대신 이 속도(pt/s)로 고정해서 dismiss와
    // 뒤로가기 진입이 항상 같은 체감 속도로 움직이게 한다.
    private let flingVelocity: CGFloat = 600 / 0.25
    // 뒤로가기 중 이전 카드를 끌어오는 속도 배수 — offscreenOffset(600pt)을 swipeThreshold
    // 근처(약 200pt) 드래그만으로 다 끌어올 수 있게 잡은 값.
    private let pullInDragMultiplier: CGFloat = 1.5

    var body: some View {
        ZStack {
            // index가 배열 순서 = 쌓인 순서라, index 0이 맨 앞(터치 가능한) 카드.
            // zIndex는 뒤집어서 index가 작을수록 위로 그려지게 함 — 단, 끌려들어오는 카드는 예외.
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
                    .zIndex(data.id == pulledInCardID ? .infinity : Double(-index))
                    .rotationEffect(rotation(for: index, cardID: data.id))
                    .offset(cardOffsets[data.id] ?? .zero)
                    // count가 바뀔 때(카드 제거)만 애니메이션 걸어서, 맨 앞으로 올라온 카드의
                    // 기울기가 rotation(for: 0)의 .zero로 스프링 애니메이션과 함께 자동으로 펴지게 함.
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: cardStackViewModel.voteCardData.count)
                    // 제스처는 카드마다 항상 붙이되, isTop이 아니면 내부에서 아무것도 안 하게 함
                    // (.gesture()에 조건부로 nil을 못 넘겨서 이렇게 우회).
                    .gesture(dragGesture(isTop: index == 0, cardID: data.id))
            }
        }
    }

    // 맨 앞 카드(0)는 끄는 방향·거리에 비례해서 기운다(틴더 스타일) — maxDragRotationDegrees에서 클램프.
    // 뒤에 쌓인 카드들은 전부 restingRotationDegrees로 통일.
    // 바로 다음 카드(1)만 앞 카드를 얼마나 드래그했는지에 비례해서 restingRotationDegrees → 0도로
    // 실시간으로 펴지게 해서, 카드가 넘어갈 때 각도가 툭 튀지 않고 자연스럽게 이어진다.
    // swipeThreshold(스와이프 확정 거리)보다 훨씬 긴 rotationUnwindDistance를 기준으로 삼아서
    // 손을 떼는 시점(threshold 근처)에는 아직 다 안 펴진 상태로, 더 끝까지 끌어야 완전히 펴지게 완화했다.
    private func rotation(for index: Int, cardID: Int) -> Angle {
        // 오른쪽에서 끌려들어오는 카드는 index로는 맨 뒤라 아래 switch로 판단이 안 되니 먼저 처리한다.
        // 오른쪽 dismiss와 완전히 같은 회전 공식(width/divisor, ±maxDragRotationDegrees 클램프)을
        // 부호 반전 없이 그대로 쓴다 — width 자체가 이미 방향(오른쪽 화면 밖 = 양수)을 담고 있어서,
        // 화면 밖(먼 거리)일 땐 dismiss와 같은 방향(+)으로 기울어져 있다가 중앙(0)에 가까워질수록
        // 평평하게 펴진다. dismiss 애니메이션을 그대로 되감는 것과 동일한 모양.
        if cardID == pulledInCardID {
            let width = (cardOffsets[cardID] ?? .zero).width
            let dragDegrees = Double(width / dragRotationDivisor)
            return .degrees(min(max(dragDegrees, -maxDragRotationDegrees), maxDragRotationDegrees))
        }
        switch index {
        case 0:
            let width = (cardOffsets[cardID] ?? .zero).width
            let dragDegrees = Double(width / dragRotationDivisor)
            return .degrees(min(max(dragDegrees, -maxDragRotationDegrees), maxDragRotationDegrees))
        case 1:
            // 맨 앞 카드가 지금 얼마나 드래그됐는지에 맞춰 펴진다 — 앞 카드 id로 조회한다.
            let topWidth = cardStackViewModel.voteCardData.first.map { (cardOffsets[$0.id] ?? .zero).width } ?? 0
            let progress = min(abs(topWidth) / rotationUnwindDistance, 1)
            return .degrees(restingRotationDegrees * (1 - progress))
        default:
            return .degrees(restingRotationDegrees)
        }
    }

    private let restingRotationDegrees: Double = -5.0
    private let rotationUnwindDistance: CGFloat = 320
    private let dragRotationDivisor: CGFloat = 20
    private let maxDragRotationDegrees: Double = 15

    private func dragGesture(isTop: Bool, cardID: Int) -> some Gesture {
        DragGesture()
            .onChanged { value in
                guard isTop else { return }
                if value.translation.width >= 0 {
                    // 오른쪽으로 끄는 중 — 기존 카드가 손가락을 그대로 따라간다(틴더 스타일 dismiss).
                    pulledInCardID = nil
                    cardOffsets[cardID] = CGSize(width: value.translation.width, height: 0)
                } else if let incomingID = cardStackViewModel.voteCardData.last?.id {
                    // 왼쪽으로 끄는 중 — "뒤로가기". 기존 카드는 그 자리에 그대로 두고, 이전 카드를
                    // 오른쪽 화면 밖(offscreenOffset)에서부터 손가락을 따라 끌고 들어오는 것처럼 보여준다.
                    // 1:1로 추적하면 600pt를 다 끌어내려야 해서 화면 끝까지도 안 나오므로,
                    // pullInDragMultiplier로 증폭해서 자연스러운 스와이프 거리 안에서 다 들어오게 한다.
                    pulledInCardID = incomingID
                    let pulledIn = max(offscreenOffset + value.translation.width * pullInDragMultiplier, 0)
                    cardOffsets[incomingID] = CGSize(width: pulledIn, height: 0)
                    cardOffsets[cardID] = .zero
                }
            }
            .onEnded { value in
                guard isTop else { return }
                let incomingID = cardStackViewModel.voteCardData.last?.id

                // 임계값 못 넘으면 스프링으로 제자리 복귀 (끌려오던 이전 카드는 다시 화면 밖으로).
                guard abs(value.translation.width) > swipeThreshold else {
                    withAnimation(.spring()) {
                        cardOffsets[cardID] = .zero
                        if let incomingID {
                            cardOffsets[incomingID] = CGSize(width: offscreenOffset, height: 0)
                        }
                    }
                    pulledInCardID = nil
                    return
                }

                // 예전엔 데이터 이동(moveTopCardToBack/moveBackCardToFront)을 withAnimation의
                // completion에서 실행했는데, SwiftUI는 값이 실제로 안 바뀌면(예: 빠르고 길게 끌어서
                // 손을 떼기 전에 이미 목표값에 도달한 경우) completion을 아예 안 부를 수 있다.
                // 그러면 다음 제스처를 막던 락이 영원히 풀리지 않아 스택 전체가 멈췄다.
                // 이제 데이터는 여기서 곧바로(동기적으로) 옮긴다 — 그래야 completion이 불리든
                // 안 불리든 다음 스와이프가 항상 즉시 반응한다. 이후 화면 밖으로 날아가거나
                // 끌려오는 나머지 움직임은 순전히 눈요기용 애니메이션이라, 그 완료 시점이 언제든
                // (또는 안 오든) 상호작용에는 전혀 영향이 없다.
                let direction: CGFloat = value.translation.width > 0 ? 1 : -1
                if direction > 0 {
                    let remaining = abs(offscreenOffset - (cardOffsets[cardID] ?? .zero).width)
                    let duration = remaining / flingVelocity
                    cardStackViewModel.moveTopCardToBack()
                    withAnimation(.easeOut(duration: duration)) {
                        cardOffsets[cardID] = CGSize(width: offscreenOffset, height: 0)
                    }
                    // 이 카드가 다음에 다시 앞으로 돌아왔을 때 깨끗한 상태이도록, 애니메이션이
                    // 끝날 시점에 오프셋을 되돌려둔다 — SwiftUI completion이 아니라 자체 타이머라
                    // 신뢰성 문제와 무관하다(늦게 리셋돼도 이 카드는 이미 배열 맨 뒤라 화면에
                    // 안 보이므로 무해하다).
                    Task {
                        try? await Task.sleep(for: .seconds(duration))
                        cardOffsets[cardID] = .zero
                    }
                } else {
                    // 왼쪽 스와이프(뒤로가기) — 이전 카드를 데이터상 즉시 맨 앞으로 올린다. index가
                    // 바로 바뀌므로 자연스러운 zIndex(index 0 = 최상단)만으로 다른 카드를 덮게 되어
                    // pulledInCardID를 더 유지할 필요가 없다. 마저 중앙까지 끌어오는 나머지 이동은
                    // 순전히 시각 효과일 뿐이다.
                    guard let incomingID else { return }
                    let remaining = (cardOffsets[incomingID] ?? .zero).width
                    cardStackViewModel.moveBackCardToFront()
                    pulledInCardID = nil
                    cardOffsets[cardID] = .zero
                    withAnimation(.easeIn(duration: remaining / flingVelocity)) {
                        cardOffsets[incomingID] = .zero
                    }
                }
            }
    }
}



#Preview {
    CardStackView(cardStackViewModel: CardStackViewModel(), onTapCard: { _ in })
}
