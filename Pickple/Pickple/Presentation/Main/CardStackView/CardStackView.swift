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
    // 오른쪽 스와이프로 넘긴 카드는 moveTopCardToBack() 호출 즉시 voteCardData에서 빠져서
    // ForEach가 그 뷰를 바로 없애버린다 — 그러면 날아가는 애니메이션을 걸 대상 자체가
    // 없어서 카드가 그냥 사라져 보였다. 날아가는 동안만 이 카드를 따로 붙잡아 별도로 그린다.
    @State private var outgoingCard: VoteCard? = nil
    // 뒤로가기 중 끌려들어오는 "이전 카드"는 voteCardData가 아니라 history에 있어서
    // ForEach가 그릴 뷰가 아예 없다 — 드래그하는 동안(그리고 확정 전까지) 이 오버레이로
    // 따로 그린다. 스와이프가 확정되면(moveBackCardToFront) 그 카드가 실제로 voteCardData에
    // 들어가서 ForEach가 이어받으므로 그 순간 이 오버레이는 치운다.
    @State private var incomingBackCard: VoteCard? = nil
    // 뒤로가기로 이전 카드가 들어와서 보이는 장수(visibleStackSize)를 넘기면, 맨 뒤 카드가
    // voteCardData에서 즉시 빠진다 — outgoingCard와 같은 이유로 그 순간 뷰가 사라져버리니,
    // 잠깐 더 붙잡아두고 페이드아웃시킨다.
    @State private var displacedCard: VoteCard? = nil

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
        // 맨 앞 카드를 지금 얼마나 끌었는지(0~1) — rotation(1,2)과 opacity(2)가 공통으로 쓴다.
        // 렌더당 한 번만 계산해서 각 카드 modifier에 넘긴다(예전엔 computed property라 카드마다 재계산됐다).
        let topWidth = cardStackViewModel.voteCardData.first.map { (cardOffsets[$0.id] ?? .zero).width } ?? 0
        let dragProgress = min(abs(topWidth) / rotationUnwindDistance, 1)

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
                    .zIndex(Double(-index))
                    .rotationEffect(rotation(for: index, cardID: data.id, dragProgress: dragProgress))
                    .opacity(opacity(for: index, dragProgress: dragProgress))
                    // count가 바뀔 때(카드 제거)만 애니메이션 걸어서, 맨 앞으로 올라온 카드의
                    // 기울기가 rotation(for: 0)의 .zero로 스프링 애니메이션과 함께 자동으로 펴지게 함.
                    // offset은 이 아래(체인 밖)에 둬서 이 스프링에 안 묶인다 — 제스처의 명시적
                    // withAnimation과 같은 프레임에 겹쳐 걸리면 두 커브가 offset을 놓고 경합해
                    // 미세하게 튀는 느낌이 있었다.
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: cardStackViewModel.voteCardData.count)
                    .offset(cardOffsets[data.id] ?? .zero)
            }

            // 뒤로가기로 끌려들어오는 이전 카드 — history에만 있고 voteCardData에는 아직
            // 없어서 ForEach로는 안 그려진다. 확정되면(incomingBackCard가 nil로 바뀌는
            // 순간) 실제로 voteCardData에 들어간 같은 카드를 ForEach가 이어서 그린다.
            if let incomingBackCard {
                CardView(
                    data: incomingBackCard,
                    myProfileImageUrl: cardStackViewModel.myProfileImageUrl,
                    onVote: { _ in },
                    onTapBody: {}
                )
                    .zIndex(.infinity)
                    .rotationEffect(rotation(for: -1, cardID: incomingBackCard.id, dragProgress: dragProgress))
                    .offset(cardOffsets[incomingBackCard.id] ?? .zero)
                    .allowsHitTesting(false)
            }

            // 방금 오른쪽으로 넘긴 카드 — voteCardData에서는 이미 빠졌지만, 화면 밖으로
            // 날아가는 애니메이션이 끝날 때까지만 별도로 계속 그려준다.
            if let outgoingCard {
                CardView(
                    data: outgoingCard,
                    myProfileImageUrl: cardStackViewModel.myProfileImageUrl,
                    onVote: { _ in },
                    onTapBody: {}
                )
                    .zIndex(.infinity)
                    .rotationEffect(rotation(for: 0, cardID: outgoingCard.id, dragProgress: dragProgress))
                    .offset(cardOffsets[outgoingCard.id] ?? .zero)
                    .allowsHitTesting(false)
            }

            // 뒤로가기로 스택이 넘쳐서 밀려난 카드 — 원래 있던 자리(맨 뒤, restingRotationDegrees)
            // 그대로 보여주다가 페이드아웃만 시킨다. 드래그로 움직이던 카드가 아니라서 날아갈
            // 필요는 없고, 순간이동하듯 뚝 끊기지만 않으면 된다.
            if let displacedCard {
                CardView(
                    data: displacedCard,
                    myProfileImageUrl: cardStackViewModel.myProfileImageUrl,
                    onVote: { _ in },
                    onTapBody: {}
                )
                    .zIndex(-.infinity)
                    .rotationEffect(.degrees(restingRotationDegrees))
                    .transition(.opacity)
                    .allowsHitTesting(false)
            }
        }
        // 제스처를 맨 앞 카드 하나하나(스와이프할 때마다 id가 바뀜)에 붙이면, 빠르게 연속으로
        // 스와이프할 때 손가락이 화면에 닿아있는 동안 그 밑 뷰의 identity가 계속 바뀌면서
        // SwiftUI 제스처 인식기가 다음 터치를 못 받아 스택 전체가 멈추는 문제가 있었다. 안 바뀌는
        // 바깥 컨테이너(ZStack)에 고정으로 붙이고, "지금 맨 앞 카드가 뭔지"는 제스처 콜백 안에서
        // 그때그때 cardStackViewModel.voteCardData.first로 조회한다.
        // SwiftUI DragGesture.onChanged 안에서 "세로면 무시"하는 가드만으로는 인식기 자체가
        // 터치를 계속 붙잡고 있어서 부모 ScrollView와 계속 경합했다(카드 위에서 세로 스크롤이
        // 씹히거나 안 먹는 문제) — DirectionalPanGestureView가 방향이 세로로 확정되는 순간
        // 인식기를 아예 실패시켜 터치를 부모에게 완전히 넘긴다.
        .overlay(
            DirectionalPanGestureView(
                onChanged: handleDragChanged,
                onEnded: handleDragEnded
            )
        )
    }

    // 맨 앞 카드(0)는 끄는 방향·거리에 비례해서 기운다(틴더 스타일) — maxDragRotationDegrees에서 클램프.
    // 뒤에 쌓인 카드들은 전부 restingRotationDegrees로 통일.
    // 바로 다음 카드(1)만 앞 카드를 얼마나 드래그했는지에 비례해서 restingRotationDegrees → 0도로
    // 실시간으로 펴지게 해서, 카드가 넘어갈 때 각도가 툭 튀지 않고 자연스럽게 이어진다.
    // swipeThreshold(스와이프 확정 거리)보다 훨씬 긴 rotationUnwindDistance를 기준으로 삼아서
    // 손을 떼는 시점(threshold 근처)에는 아직 다 안 펴진 상태로, 더 끝까지 끌어야 완전히 펴지게 완화했다.
    private func rotation(for index: Int, cardID: Int, dragProgress: Double) -> Angle {
        // 오른쪽에서 끌려들어오는 카드는 index로는 맨 뒤라 아래 switch로 판단이 안 되니 먼저 처리한다.
        // 오른쪽 dismiss와 완전히 같은 회전 공식(width/divisor, ±maxDragRotationDegrees 클램프)을
        // 부호 반전 없이 그대로 쓴다 — width 자체가 이미 방향(오른쪽 화면 밖 = 양수)을 담고 있어서,
        // 화면 밖(먼 거리)일 땐 dismiss와 같은 방향(+)으로 기울어져 있다가 중앙(0)에 가까워질수록
        // 평평하게 펴진다. dismiss 애니메이션을 그대로 되감는 것과 동일한 모양.
        if cardID == pulledInCardID || index == 0 {
            let width = (cardOffsets[cardID] ?? .zero).width
            let dragDegrees = Double(width / dragRotationDivisor)
            return .degrees(min(max(dragDegrees, -maxDragRotationDegrees), maxDragRotationDegrees))
        }
        switch index {
        case 1:
            // 맨 앞 카드가 지금 얼마나 드래그됐는지에 맞춰 펴진다 — 앞 카드 id로 조회한다.
            return .degrees(restingRotationDegrees * (1 - dragProgress))
        case 2:
            // 3번째 카드는 평소엔 더 눕혀진 각도(deepRestingRotationDegrees)로 살짝 숨어있다가,
            // 앞 카드를 끄는 만큼 2번째 카드의 각도(restingRotationDegrees)로 따라 펴진다 —
            // opacity(for:)와 같은 진행도(dragProgress)를 써서 회전과 등장이 같이 맞물린다.
            return .degrees(deepRestingRotationDegrees + (restingRotationDegrees - deepRestingRotationDegrees) * dragProgress)
        default:
            return .degrees(restingRotationDegrees)
        }
    }

    // 3번째 카드가 서서히 나타나는 정도 — 평소엔 거의 안 보이다가 앞 카드를 끄는 만큼
    // (rotation의 dragProgress와 같은 기준으로) 점점 또렷해진다.
    private func opacity(for index: Int, dragProgress: Double) -> Double {
        guard index == 2 else { return 1 }
        return dragProgress
    }

    private let restingRotationDegrees: Double = -5.0
    private let deepRestingRotationDegrees: Double = -10.0
    private let rotationUnwindDistance: CGFloat = 320
    private let dragRotationDivisor: CGFloat = 20
    private let maxDragRotationDegrees: Double = 15

    private func handleDragChanged(_ translation: CGSize) {
        guard let cardID = cardStackViewModel.voteCardData.first?.id else { return }
        if translation.width >= 0 {
            // 오른쪽으로 끄는 중 — 기존 카드가 손가락을 그대로 따라간다(틴더 스타일 dismiss).
            // 손가락이 완벽한 직선이 아니라 드래그 초반에 살짝 왼쪽으로 흔들렸다가
            // 바로잡는 경우가 있는데, 그 찰나에 세팅된 incomingBackCard를 여기서 안
            // 지우면 왼쪽 스와이프를 확정할 때만 지워지는 구조라 취소/오른쪽 스와이프
            // 후에도 이전 카드 오버레이가 zIndex(.infinity)로 계속 화면을 덮고 있었다.
            pulledInCardID = nil
            incomingBackCard = nil
            cardOffsets[cardID] = CGSize(width: translation.width, height: 0)
        } else if let previous = cardStackViewModel.previousCard {
            // 왼쪽으로 끄는 중 — "뒤로가기". 기존 카드는 그 자리에 그대로 두고, 이전 카드를
            // 오른쪽 화면 밖(offscreenOffset)에서부터 손가락을 따라 끌고 들어오는 것처럼 보여준다.
            // 1:1로 추적하면 600pt를 다 끌어내려야 해서 화면 끝까지도 안 나오므로,
            // pullInDragMultiplier로 증폭해서 자연스러운 스와이프 거리 안에서 다 들어오게 한다.
            let incomingID = previous.id
            pulledInCardID = incomingID
            incomingBackCard = previous
            let pulledIn = max(offscreenOffset + translation.width * pullInDragMultiplier, 0)
            cardOffsets[incomingID] = CGSize(width: pulledIn, height: 0)
            cardOffsets.removeValue(forKey: cardID)
        }
    }

    private func handleDragEnded(_ translation: CGSize) {
        guard let cardID = cardStackViewModel.voteCardData.first?.id else { return }
        let incomingID = cardStackViewModel.previousCard?.id

        // 임계값 못 넘으면 스프링으로 제자리 복귀 (끌려오던 이전 카드는 다시 화면 밖으로).
        guard abs(translation.width) > swipeThreshold else {
            withAnimation(.spring()) {
                cardOffsets.removeValue(forKey: cardID)
                if let incomingID {
                    cardOffsets[incomingID] = CGSize(width: offscreenOffset, height: 0)
                }
            }
            pulledInCardID = nil
            incomingBackCard = nil
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
        let direction: CGFloat = translation.width > 0 ? 1 : -1
        if direction > 0 {
            // onChanged에서 이미 지워지지만(방향이 오른쪽이면), 방어적으로 한 번 더.
            incomingBackCard = nil
            let remaining = abs(offscreenOffset - (cardOffsets[cardID] ?? .zero).width)
            let duration = remaining / flingVelocity
            // moveTopCardToBack()이 부르는 즉시 이 카드는 voteCardData에서 빠져서
            // ForEach가 뷰를 없애버리므로, 날아가는 동안 보여줄 스냅샷을 먼저 붙잡아둔다.
            outgoingCard = cardStackViewModel.voteCardData.first
            cardStackViewModel.moveTopCardToBack()
            // 이 카드가 다음에 다시 앞으로 돌아왔을 때(재활용 등) 깨끗한 상태이도록,
            // 애니메이션이 실제로 끝나는 시점에 오프셋을 정리하고 outgoingCard 스냅샷도
            // 치운다 — 추정 duration으로 별도 타이머를 재는 대신, withAnimation의
            // completion 콜백을 써서 실제 렌더 종료와 정확히 맞물리게 한다.
            withAnimation(.easeOut(duration: duration)) {
                cardOffsets[cardID] = CGSize(width: offscreenOffset, height: 0)
            } completion: {
                cardOffsets.removeValue(forKey: cardID)
                outgoingCard = nil
            }
        } else {
            // 왼쪽 스와이프(뒤로가기) — 이전 카드를 데이터상 즉시 맨 앞으로 올린다. index가
            // 바로 바뀌므로 자연스러운 zIndex(index 0 = 최상단)만으로 다른 카드를 덮게 되어
            // pulledInCardID를 더 유지할 필요가 없다. 마저 중앙까지 끌어오는 나머지 이동은
            // 순전히 시각 효과일 뿐이다.
            guard let incomingID else { return }
            let remaining = (cardOffsets[incomingID] ?? .zero).width
            let displaced = cardStackViewModel.moveBackCardToFront()
            // 이제 이 카드가 실제로 voteCardData에 들어갔으니, ForEach가 이어서
            // 그리도록(같은 cardOffsets를 계속 읽으므로 끊김 없이 이어짐) 오버레이는 치운다.
            incomingBackCard = nil
            pulledInCardID = nil
            cardOffsets.removeValue(forKey: cardID)
            withAnimation(.easeIn(duration: remaining / flingVelocity)) {
                cardOffsets[incomingID] = .zero
            } completion: {
                cardOffsets.removeValue(forKey: incomingID)
            }

            if let displaced {
                // .transition(.opacity)가 등장은 즉시, 퇴장은 여기서 애니메이션해준 대로
                // 페이드아웃시켜준다 — 별도 opacity 상태나 타이머 없이 SwiftUI에 맡긴다.
                displacedCard = displaced
                withAnimation(.easeOut(duration: 0.2)) {
                    displacedCard = nil
                }
            }
        }
    }
}



#Preview {
    CardStackView(cardStackViewModel: CardStackViewModel(), onTapCard: { _ in })
}
