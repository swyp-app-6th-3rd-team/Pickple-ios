//
//  MyPageInfoRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//
// 1차 점검 완료 - 9월 13일

import SwiftUI

struct MyPageInfoRow: View {
    let iconName: String
    let title: String
    // 외부 링크로 여는 행(예: 버전 정보)과 화면 내 이동/다이얼로그를 띄우는 행(예: 나의 등급)이
    // 레이아웃은 동일해서, url 유무로 Link/Button만 갈라 하나의 컴포넌트를 공유한다.
    var url: String? = nil
    var action: () -> Void = {}

    var body: some View {
        Group {
            if let url, let destination = URL(string: url) {
                Link(destination: destination) { rowContent }
            } else {
                Button(action: action) { rowContent }
            }
        }
    }

    private var rowContent: some View {
        HStack {
            HStack(spacing: 10) {
                Image(iconName)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.neutral30)

                Text(title)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.black)
            }

            Spacer()

            Image("PickpleArrowRight")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundStyle(Color.neutral30)
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    MyPageInfoRow(iconName: "PickpleMyGrade", title: "나의 등급", action: {})
}
