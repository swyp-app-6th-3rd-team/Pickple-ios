//
//  SplashView.swift
//  Pickple
//
//  Created by 박윤수 on 9/10/26.
//
//  세션 복원(PickpleApp.isRestoringSession) 중에만 잠깐 보이는 화면. 시스템 런치
//  스크린(Info.plist)과는 별개로, 앱 코드가 실제로 로그인 상태를 확인하는 동안의
//  화면이 비어 보이지 않게 하는 용도.
// 1차 점검 완료 - 9월 13일

import SwiftUI

struct SplashView: View {
    var body: some View {
        Color.navy60
            .ignoresSafeArea()
            .overlay {
                Image("Logo")
                    .resizable()
                    .frame(width: 200, height: 45)
            }
    }
}

#Preview {
    SplashView()
}
