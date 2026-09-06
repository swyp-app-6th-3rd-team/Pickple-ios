//
//  TermsAgreementView.swift
//  Pickple
//
//  Created by 박윤수 on 9/6/26.
//
//  TODO: 실제 UI(전체동의 토글, 서비스 이용약관/개인정보 수집 동의 항목, 각 항목 클릭 시 노션 링크 연결) 채울 것.
//  지금은 신규 가입자가 이 화면을 거쳐 온다는 것만 확인 가능한 빈 상태.

import SwiftUI

struct TermsAgreementView: View {
    var onCompleted: () -> Void = {}

    var body: some View {
        VStack {
            Spacer()
            Button("확인") {
                onCompleted()
            }
            Spacer()
        }
    }
}

#Preview {
    TermsAgreementView()
}
