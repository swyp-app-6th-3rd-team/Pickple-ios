//
//  DismissKeyboardOnTap.swift
//  Pickple
//
//  Created by 박윤수 on 9/17/26.
//
//  텍스트필드 바깥을 탭하면 키보드가 내려가게 한다. 앱 루트 한 곳에만 적용해서 모든
//  화면에 공통으로 적용된다.
//
//  원래 순수 SwiftUI TapGesture(.simultaneousGesture)로 만들었는데, 이 방식은 "이 탭이
//  텍스트필드 위인지"를 구분할 방법이 없다 — 그래서 이미 포커스된 필드를 탭해 커서를
//  옮기거나 붙여넣기 메뉴를 띄우는 순간에도 같이 인식돼 resignFirstResponder가 불려서
//  메뉴가 바로 사라지는 문제가 있었다. UIKit UITapGestureRecognizer로 바꾸고 델리게이트의
//  shouldReceive(touch:)로 탭 대상이 텍스트 입력 뷰(또는 그 하위)면 애초에 인식하지
//  않게 한다.

import SwiftUI
import UIKit

extension View {
    func dismissKeyboardOnTap() -> some View {
        gesture(DismissKeyboardTapGesture())
    }
}

@available(iOS 18.0, *)
private struct DismissKeyboardTapGesture: UIGestureRecognizerRepresentable {
    func makeUIGestureRecognizer(context: Context) -> UITapGestureRecognizer {
        let recognizer = UITapGestureRecognizer()
        recognizer.delegate = context.coordinator
        recognizer.cancelsTouchesInView = false
        return recognizer
    }

    func handleUIGestureRecognizerAction(_ recognizer: UITapGestureRecognizer, context: Context) {
        guard recognizer.state == .ended else { return }
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            !(touch.view?.isTextInputOrDescendant ?? false)
        }

        // 다른 탭/버튼 제스처를 막지 않는다 — 기존 simultaneousGesture와 같은 의도.
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            true
        }
    }
}

private extension UIView {
    var isTextInputOrDescendant: Bool {
        var view: UIView? = self
        while let current = view {
            if current is UITextField || current is UITextView { return true }
            view = current.superview
        }
        return false
    }
}
