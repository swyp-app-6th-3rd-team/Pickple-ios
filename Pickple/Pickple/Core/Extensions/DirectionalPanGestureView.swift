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
//  부모 ScrollView가 곧바로 이어받는다 — UIKit interop이 필요한 이유.

import SwiftUI
import UIKit

private final class DirectionalPanGestureRecognizer: UIPanGestureRecognizer {
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
// 뷰에 붙인다. translation은 SwiftUI DragGesture와 동일하게 CGSize(width, height)로 준다.
struct DirectionalPanGestureView: UIViewRepresentable {
    var onChanged: (CGSize) -> Void
    var onEnded: (CGSize) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onChanged: onChanged, onEnded: onEnded)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        let recognizer = DirectionalPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        recognizer.delegate = context.coordinator
        view.addGestureRecognizer(recognizer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.onChanged = onChanged
        context.coordinator.onEnded = onEnded
    }

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var onChanged: (CGSize) -> Void
        var onEnded: (CGSize) -> Void

        init(onChanged: @escaping (CGSize) -> Void, onEnded: @escaping (CGSize) -> Void) {
            self.onChanged = onChanged
            self.onEnded = onEnded
        }

        @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
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

        // 방향이 확정되기 전까지는 부모 ScrollView의 팬 제스처도 같이 인식되게 허용한다 —
        // 그래야 우리 쪽이 .failed로 넘어가는 순간 부모가 이미 같이 추적하던 터치를 끊김 없이 이어받는다.
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            true
        }
    }
}
