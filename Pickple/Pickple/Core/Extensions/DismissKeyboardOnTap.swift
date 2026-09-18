//
//  DismissKeyboardOnTap.swift
//  Pickple
//
//  Created by 박윤수 on 9/17/26.
//
//  텍스트필드 바깥을 탭하면 키보드가 내려가게 한다. 앱 루트 한 곳에만 적용해서 모든
//  화면에 공통으로 적용되며, simultaneousGesture라 화면의 다른 탭/버튼 제스처를 막지 않는다.

import SwiftUI
import UIKit

extension View {
    func dismissKeyboardOnTap() -> some View {
        simultaneousGesture(
            TapGesture().onEnded {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        )
    }
}
