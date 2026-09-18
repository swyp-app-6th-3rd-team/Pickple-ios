//
//  SwipeBackGesture.swift
//  Pickple
//
//  Created by 박윤수 on 9/17/26.
//
//  .navigationBarBackButtonHidden(true)를 쓰면(커스텀 GNB 백버튼을 쓰는 화면들) SwiftUI가
//  왼쪽 가장자리 스와이프 뒤로가기 제스처(interactivePopGestureRecognizer)까지 같이 꺼버린다
//  — NavigationStack의 잘 알려진 제약이라 순수 SwiftUI로는 우회할 방법이 없다. UIKit으로
//  내려가서 그 제스처를 직접 다시 켜준다(SwiftUI 커뮤니티에 널리 알려진 표준 우회법).

import SwiftUI
import UIKit

private struct SwipeBackGestureEnabler: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // 이 뷰컨트롤러가 실제 네비게이션 스택에 올라간 뒤에야 navigationController를
        // 찾을 수 있어서 한 런루프 뒤로 미룬다.
        DispatchQueue.main.async {
            guard let navigationController = uiViewController.navigationController else { return }
            navigationController.interactivePopGestureRecognizer?.delegate = nil
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}

extension View {
    // .navigationBarBackButtonHidden(true)와 같이 써서 커스텀 백버튼을 쓰면서도
    // 왼쪽 가장자리 스와이프 뒤로가기는 유지한다.
    func restoresSwipeBackGesture() -> some View {
        background(SwipeBackGestureEnabler().frame(width: 0, height: 0))
    }
}
