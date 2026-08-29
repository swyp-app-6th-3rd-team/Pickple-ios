//
//  PickpleButton.swift
//  Pickple
//
//  Created by 박윤수 on 8/27/26.
//
//  TODO: 디자인 확정 후 변경 필요
//  - 색상: Color.black/gray/white → Asset Catalog 컬러셋으로 교체
//  - 폰트: "Nunito-ExtraBold" 하드코딩 → 폰트명/크기 확정 후 상수로 교체
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
            .pickpleTypography(.body01)
            .foregroundStyle(foregroundColor)
            .frame(width: 353, height: 56)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .opacity(configuration.isPressed ? 0.7 : 1)   // 눌렀을 때 반응
    }

    private var backgroundColor: Color {
        switch style {
        case ._default: return Color.navy10
        case .line: return Color.white
        case .disabled: return Color.neutral20
        case .enabled: return Color.neutral100
        }
    }

    private var foregroundColor: Color {
        switch style {
        case ._default: return Color.neutral100
        case .line: return Color.neutral100
        case .disabled: return Color.neutral40
        case .enabled: return Color.white
        }
    }
}

// 다른 파일에서 .pickple(.primary) 형태로 쓰려면
extension ButtonStyle where Self == PickpleButton {
    static func pickple(_ style: PickpleButtonStyle) -> PickpleButton {
        PickpleButton(style: style)
    }
}
