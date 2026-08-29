//
//  LoginView.swift
//  Pickple
//
//  Created by 박윤수 on 8/24/26.
//

//버튼 기능 추가해야함

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {

            Spacer()

            //MARK: - Title & Image
            VStack(spacing: 31) {
                Image("PickpleLoginLogo")

                VStack(spacing: 51) {
                    Image("PickpleLoginIllustration")
                        .frame(width: 269, height: 262)

                    //MARK: - Login Buttons
                    VStack(spacing: 8) {
                        LoginButton(provider: .kakao) { /*Kakao 로그인 구현*/ }
                        LoginButton(provider: .apple) { /*Apple 로그인 구현*/ }
                        LoginButton(provider: .guest) { /*Guest 로그인 구현*/ }
                    }
                }
            }

            Spacer()
            
            Text(LoginStrings.termsNotice)
                .pickpleTypography(.caption)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.termsNoticeText)

        }
    }
}


#Preview {
    LoginView()
}
