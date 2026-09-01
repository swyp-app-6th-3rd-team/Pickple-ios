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
        VStack(spacing: 40) {
            Spacer()

            //MARK: - Title
            VStack(spacing: 7) {
                Image("PickpleLoginLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 200)

                //XMARK: - OnBoardingImage
                VStack(spacing: 0) {
                    Image("PickpleOnBoardingImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 350)

                    //MARK: - Login Buttons
                    VStack(spacing: 8) {
                        LoginButton(provider: .kakao) { /*Kakao 로그인 구현*/ }
                        LoginButton(provider: .apple) { /*Apple 로그인 구현*/ }
                        LoginButton(provider: .guest) { /*Guest 로그인 구현*/ }
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            //XMARK: - Text
            Text(LoginStrings.termsNotice)
                .pickpleTypography(.caption)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.neutral30)

        }
    }
}


#Preview {
    LoginView()
}
