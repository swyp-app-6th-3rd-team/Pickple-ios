//
//  DirectionalPanGestureView.swift
//  Pickple
//
//  Created by 박윤수 on 9/18/26.
//
//  SwiftUI DragGesture.onChanged 안에서 "세로면 무시" 가드를 걸어도, 제스처 인식기 자체는
//  터치를 계속 붙잡고 있어서 부모 ScrollView와 미묘하게 경합한다 — 카드 위에서 세로로
//  쓸었을 때 스크롤이 안 먹거나 씹히는 원인. UIPanGestureRecognizer를 직접 서브클래싱해서
//  방향이 세로로 확정되는 순간 인식기를 아예 .failed로 전환해 터치를 놓아버리면, 그 순간부터
//  부모 ScrollView가 곧바로 이어받는다.
//
//  처음엔 UIViewRepresentable + .overlay()로 붙였는데, 그러면 카드 전체를 덮는 실체 있는
//  UIView가 생겨서 그 아래 SwiftUI 버튼(투표 버튼 등)의 터치를 히트테스트에서 통째로
//  가로채 버렸다(터치가 안 먹는 문제). iOS 18의 UIGestureRecognizerRepresentable로 붙이면
//  .gesture()를 통해 SwiftUI 자체 제스처 동시인식 체계에 들어가서, 덮는 뷰 없이도 같은
//  방향 판별 로직이 Button/onTapGesture와 자연스럽게 공존한다.

import SwiftUI
import UIKit

final class DirectionalPanGestureRecognizer: UIPanGestureRecognizer {
    private var startLocation: CGPoint?
    // 이 정도는 움직여야 방향을 판단한다 — 너무 이르면 손떨림으로 오판한다.
    private let directionLockDistance: CGFloat = 4

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        startLocation = touches.first?.location(in: view)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if let startLocation, state == .possible, let current = touches.first?.location(in: view) {
            let dx = current.x - startLocation.x
            let dy = current.y - startLocation.y
            if max(abs(dx), abs(dy)) > directionLockDistance {
                if abs(dy) > abs(dx) {
                    // 아직 .began 전이라, 여기서 실패시키면 이 제스처는 시작조차 안 한 게 되고
                    // 터치는 곧바로 다른 인식기(부모 ScrollView의 팬)로 넘어간다.
                    state = .failed
                    return
                }
                self.startLocation = nil // 가로로 확정 — 이후엔 정상적인 팬 처리에 맡긴다.
            }
        }
        super.touchesMoved(touches, with: event)
    }

    override func reset() {
        super.reset()
        startLocation = nil
    }
}

// 카드스택 같이 "가로로 끌 때만 반응하고, 세로일 땐 부모 스크롤에 완전히 양보해야 하는"
// 뷰에 .gesture()로 붙인다. translation은 SwiftUI DragGesture와 동일하게 CGSize(width, height)로 준다.
@available(iOS 18.0, *)
struct DirectionalPanGesture: UIGestureRecognizerRepresentable {
    var onChanged: (CGSize) -> Void
    var onEnded: (CGSize) -> Void

    func makeUIGestureRecognizer(context: Context) -> DirectionalPanGestureRecognizer {
        let recognizer = DirectionalPanGestureRecognizer()
        recognizer.delegate = context.coordinator
        return recognizer
    }

    func handleUIGestureRecognizerAction(_ recognizer: DirectionalPanGestureRecognizer, context: Context) {
        let translation = recognizer.translation(in: recognizer.view)
        let size = CGSize(width: translation.x, height: translation.y)
        switch recognizer.state {
        case .began, .changed:
            onChanged(size)
        case .ended:
            onEnded(size)
        case .cancelled:
            onEnded(.zero)
        default:
            break
        }
    }

    func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        // 방향이 확정되기 전까지는 부모 ScrollView의 팬 제스처도 같이 인식되게 허용한다 —
        // 그래야 우리 쪽이 .failed로 넘어가는 순간 부모가 이미 같이 추적하던 터치를 끊김 없이 이어받는다.
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            true
        }
    }
}
