//
//  LoginView.swift
//  Pickple
//
//  Created by 박윤수 on 8/24/26.
//

//폰트 변경해야함
//실제 이미지 변경해야함
//로그인 버튼 로고 추가해야함

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack(spacing: 0) {

            Spacer()

            //MARK: - Title & Image
            VStack(spacing: 19) {
                Text("Pickple")
                    

                VStack(spacing: 51) {
                    Rectangle() //실제 이미지로 변경 예정
                        .frame(width: 269, height: 262)
                        .foregroundStyle(Color.red)

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
