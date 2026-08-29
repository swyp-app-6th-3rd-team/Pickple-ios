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

enum PickpleFontWeight: String {
    case bold = "Pretendard-Bold"
    case semibold = "Pretendard-SemiBold"
    case medium = "Pretendard-Medium"
    case regular = "Pretendard-Regular"
}

enum PickpleTypography {
    case heading01
    case heading02
    case title01
    case title02
    case body01Bold
    case body01
    case body02
    case label
    case caption

    var weight: PickpleFontWeight {
        switch self {
        case .heading01, .heading02, .title01: return .bold
        case .title02, .body01Bold, .body02, .label: return .semibold
        case .body01: return .medium
        case .caption: return .regular
        }
    }

    var size: CGFloat {
        switch self {
        case .heading01, .heading02: return 28
        case .title01: return 20
        case .title02, .body01Bold: return 18
        case .body01: return 16
        case .body02: return 14
        case .label: return 13
        case .caption: return 12
        }
    }

    var lineHeightPercent: CGFloat {
        switch self {
        case .heading01, .heading02: return 1.35
        case .title01: return 1.40
        case .title02, .body01Bold, .body02: return 1.45
        case .body01, .caption: return 1.50
        case .label: return 1.40
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

    // SwiftUI lineSpacing은 줄 사이 "추가" 간격이라 CSS line-height와 1:1 대응은 아님.
    // 폰트 자체 줄간격을 뺀 근사치로 계산.
    var lineSpacing: CGFloat {
        size * (lineHeightPercent - 1)
    }
}

extension View {
    func pickpleTypography(_ style: PickpleTypography) -> some View {
        self
            .font(style.font)
            .tracking(style.tracking)
            .lineSpacing(style.lineSpacing)
    }
}
