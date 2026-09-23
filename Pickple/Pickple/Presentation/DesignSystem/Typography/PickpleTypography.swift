//
//  PickpleTypography.swift
//  Pickple
//
//  Created by 박윤수 on 8/29/26.
//
//  TODO: Pretendard 폰트 파일(.otf/.ttf) 프로젝트 추가 및 Info.plist UIAppFonts 등록 필요
//  - 등록 전까지 .custom() 폰트 이름이 매칭되지 않아 시스템 기본 폰트로 폴백됨
//

import SwiftUI
// UIFont: 텍스트 폭을 GeometryReader 없이 동기적으로 측정하려면 NSString 측정 API가
// 필요한데, 그건 UIKit의 UIFont를 요구한다.
import UIKit

enum PickpleFontWeight: String {
    case bold = "Pretendard-Bold"
    case semibold = "Pretendard-SemiBold"
    case medium = "Pretendard-Medium"
    case regular = "Pretendard-Regular"
}

// 스타일당 굵기가 여러 개인 경우(Title02/Body01/Body02/Label/Caption) 케이스 이름에
// 굵기를 붙여 구분한다(_600/_500/_400). 굵기가 하나뿐인 스타일(Heading/Title01)은
// 접미사 없이 그대로 쓴다.
enum PickpleTypography {
    case heading01
    case heading02
    case title01
    case title01_600
    case title02_600
    case title02_400
    case body01_600
    case body01_500
    case body01_400
    case body02_600
    case body02_500
    case body02_400
    case label_600
    case label_500
    case label_400
    case caption_600
    case caption_400

    var weight: PickpleFontWeight {
        switch self {
        case .heading01, .heading02, .title01: return .bold
        case .title01_600, .title02_600, .body01_600, .body02_600, .label_600, .caption_600: return .semibold
        case .body01_500, .body02_500, .label_500: return .medium
        case .title02_400, .body01_400, .body02_400, .label_400, .caption_400: return .regular
        }
    }

    private static let tempRenderingGapScale: CGFloat = 1.06 // 폰트 크기 보정값

    var size: CGFloat {
        let base: CGFloat
        switch self {
        case .heading01: base = 28
        case .heading02: base = 28
        case .title01_600, .title01: base = 20
        case .title02_600, .title02_400: base = 18
        case .body01_600, .body01_500, .body01_400: base = 16
        case .body02_600, .body02_500, .body02_400: base = 14
        case .label_600, .label_500, .label_400: base = 13
        case .caption_600, .caption_400: base = 12
        }
        return base * Self.tempRenderingGapScale
    }

    var lineHeightPercent: CGFloat {
        switch self {
        case .heading01, .heading02: return 1.35
        case .title01, .title01_600: return 1.40
        case .title02_600, .title02_400, .body02_600, .body02_500, .body02_400: return 1.45
        case .body01_600, .body01_500, .body01_400, .caption_600, .caption_400: return 1.50
        case .label_600, .label_500, .label_400: return 1.40
        }
    }

    // 모든 스타일 공통 -2%
    private var letterSpacingPercent: CGFloat { -0.02 }

    var font: Font {
        .custom(weight.rawValue, size: size)
    }

    var tracking: CGFloat {
        size * letterSpacingPercent
    }

    // SwiftUI .lineSpacing()은 폰트 기본 줄 높이 "위에 추가로" 더하는 값이라, Figma의
    // "줄 높이 배수"(폰트 크기 * lineHeightPercent)와 그대로 안 맞는다 — 목표 줄 높이에서
    // 폰트가 이미 갖고 있는 기본 줄 높이(uiFont.lineHeight)를 뺀 차이만 추가로 넘긴다.
    var lineSpacing: CGFloat {
        max(size * lineHeightPercent - uiFont.lineHeight, 0)
    }

    // GeometryReader로 렌더링된 텍스트 폭을 측정해 상태에 반영하는 방식은 SwiftUI
    // 렌더링 타이밍에 따라 결과가 들쭉날쭉했다. NSString 기반으로 같은 폰트를 동기적으로
    // 측정하면 매 렌더링마다 항상 같은 값이 나와 그런 문제가 없다.
    var uiFont: UIFont {
        UIFont(name: weight.rawValue, size: size) ?? .systemFont(ofSize: size, weight: weight.uiFontWeight)
    }
}

private extension PickpleFontWeight {
    var uiFontWeight: UIFont.Weight {
        switch self {
        case .bold: return .bold
        case .semibold: return .semibold
        case .medium: return .medium
        case .regular: return .regular
        }
    }
}

extension View {
    func pickpleTypography(_ style: PickpleTypography) -> some View {
        self
            .font(style.font)
            .tracking(style.tracking)
            .lineSpacing(style.lineSpacing)
            // .lineSpacing()은 각 줄 아래에만 붙어서 첫 줄 위쪽엔 안 생긴다 — Figma가 한 줄이어도
            // line-height만큼 위아래로 공간을 갖는 것과 맞추려고 절반씩 위아래에 패딩으로 채운다.
            .padding(.vertical, style.lineSpacing / 2)
    }
}
