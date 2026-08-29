//
//  LoginButton.swift
//  Pickple
//
//  Created by 박윤수 on 8/26/26.
//

import SwiftUI

enum LoginProvider {
    case kakao
    case apple
    case guest

    var title: String {
        switch self {
        case .kakao: return LoginStrings.kakaoLogin
        case .apple: return LoginStrings.appleLogin
        case .guest: return LoginStrings.guestLogin
        }
    }

    var backgroundColor: Color {
        switch self {
        case .kakao: return Color.kakao
        case .apple: return Color.apple
        case .guest: return Color.guest
        }
    }

    var foregroundColor: Color {
        switch self {
        case .kakao: return Color.textPrimary
        case .apple: return Color.textOnDark
        case .guest: return Color.textSecondary
        }
    }

    var borderColor: Color? {
        switch self {
        case .guest: return Color.guestBorder
        default: return nil
        }
    }
}

struct LoginButton: View {
    let provider: LoginProvider
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 353, height: 56)
                    .foregroundStyle(provider.backgroundColor)
                    .overlay {
                        if let borderColor = provider.borderColor {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(borderColor, lineWidth: 1)
                        }
                    }

                Text(provider.title)
                    .pickpleTypography(.body01Bold)
                    .foregroundStyle(provider.foregroundColor)
            }
        }
    }
}
