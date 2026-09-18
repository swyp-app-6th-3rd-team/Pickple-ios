//
//  ScrollDirectionDetector.swift
//  Pickple
//
//  Created by 박윤수 on 9/18/26.
//
//  순수 SwiftUI의 .onScrollGeometryChange는 contentOffset을 매 프레임 샘플링해서 방향을
//  추론하는 방식이라, LazyVStack이 화면에 새로 들어오는 셀의 실제 높이를 뒤늦게 측정해
//  보정할 때 생기는 순간적인 오프셋 튐까지 "방향 반전"으로 잘못 잡는 문제가 있었다(디바운스로
//  걸러내 봤지만 반응이 살짝 늦어지는 트레이드오프가 생겼다).
//  UIScrollView의 panGestureRecognizer가 보고하는 velocity는 손가락 추적 자체에서 나오는
//  값이라 콘텐츠 크기 변화와 완전히 무관하다 — 이게 필요해서 UIKit interop을 쓴다.

import SwiftUI
import UIKit

private extension UIView {
    var enclosingScrollView: UIScrollView? {
        var current = superview
        while let view = current {
            if let scrollView = view as? UIScrollView { return scrollView }
            current = view.superview
        }
        return nil
    }
}

// ScrollView의 "콘텐츠 쪽"(안)에 크기 없이 끼워 넣어야 한다 — 그래야 조상을 타고 올라가서
// 실제 UIScrollView를 찾을 수 있다. ScrollView 바깥(.background 등)에 붙이면 형제 관계라
// 못 찾는다.
struct ScrollDirectionDetector: UIViewRepresentable {
    var onDirectionChange: (Bool) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onDirectionChange: onDirectionChange)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        // 이 뷰가 아직 계층에 완전히 붙기 전이라 바로 조상을 찾으면 실패할 수 있어 한 틱 미룬다.
        DispatchQueue.main.async {
            context.coordinator.attach(to: view)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.onDirectionChange = onDirectionChange
    }

    final class Coordinator: NSObject {
        var onDirectionChange: (Bool) -> Void
        private weak var scrollView: UIScrollView?
        // 손떨림 수준의 아주 작은 속도까지 방향으로 잡지 않기 위한 최소값(pt/s).
        private let velocityThreshold: CGFloat = 20

        init(onDirectionChange: @escaping (Bool) -> Void) {
            self.onDirectionChange = onDirectionChange
        }

        func attach(to view: UIView) {
            guard scrollView == nil, let found = view.enclosingScrollView else { return }
            scrollView = found
            found.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
        }

        @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
            guard let scrollView, gesture.state == .changed else { return }
            let velocityY = gesture.velocity(in: scrollView).y
            guard abs(velocityY) > velocityThreshold else { return }
            // 손가락이 위로 움직이면(velocity가 음수) 콘텐츠는 아래로 스크롤되는 것이다.
            onDirectionChange(velocityY < 0)
        }

        deinit {
            scrollView?.panGestureRecognizer.removeTarget(self, action: #selector(handlePan(_:)))
        }
    }
}

extension View {
    // 하단 탭바 숨김/노출처럼, 콘텐츠 크기 변화(무한스크롤, LazyVStack 등)에 영향받지 않는
    // 정확한 스크롤 방향이 필요할 때 쓴다. 반드시 ScrollView의 콘텐츠 쪽에 붙여야 한다.
    func onScrollDirectionChange(perform action: @escaping (_ isScrollingDown: Bool) -> Void) -> some View {
        background(ScrollDirectionDetector(onDirectionChange: action))
    }
}
