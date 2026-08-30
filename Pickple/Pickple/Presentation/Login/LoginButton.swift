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
        case .kakao: return Color.black
        case .apple: return Color.white
        case .guest: return Color.neutral60
        }
    }

    var borderColor: Color? {
        switch self {
        case .guest: return Color.guestBorder
        default: return nil
        }
    }

    var icon: Image? {
        switch self {
        case .kakao: return Image("PickpleKakaoLogo")
        case .apple: return Image("PickpleAppleLogo")
        case .guest: return nil
        }
    }
}

struct LoginButton: View {
    let provider: LoginProvider
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Text(provider.title)
                    .pickpleTypography(.title02)
                    .foregroundStyle(provider.foregroundColor)

                if let icon = provider.icon {
                    icon
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            // 높이는 실제 콘텐츠(텍스트/아이콘) 기준으로 정하고, 배경은 그 크기를 그대로 따라가게 한다.
            // 배경 도형에 직접 frame을 걸면 Shape가 남는 공간을 다 채우려는 기본 동작 때문에 높이가 부풀 수 있다.
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(provider.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                if let borderColor = provider.borderColor {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(borderColor, lineWidth: 1)
                }
            }
        }
    }
}
