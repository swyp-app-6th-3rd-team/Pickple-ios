//
//  PickpleButton.swift
//  Pickple
//
//  Created by 박윤수 on 8/27/26.
//

import Foundation
import SwiftUI

enum PickpleButtonStyle {
    case _default
    case line
    case disabled
    case enabled
}

struct PickpleButton: ButtonStyle {
    let style: PickpleButtonStyle

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("Nunito-ExtraBold", size: 16))
            .foregroundStyle(foregroundColor)
            .frame(width: 353, height: 56)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .opacity(configuration.isPressed ? 0.7 : 1)   // 눌렀을 때 반응
    }

    private var backgroundColor: Color {
        switch style {
        case ._default: return Color.black
        case .line: return Color.gray
        case .disabled: return Color.white
        case .enabled: return Color.gray
        }
    }

    private var foregroundColor: Color {
        switch style {
        case ._default: return Color.white
        case .line: return Color.white
        case .disabled: return Color.black
        case .enabled: return Color.black
        }
    }
}

// 다른 파일에서 .pickple(.primary) 형태로 쓰려면
extension ButtonStyle where Self == PickpleButton {
    static func pickple(_ style: PickpleButtonStyle) -> PickpleButton {
        PickpleButton(style: style)
    }
}
