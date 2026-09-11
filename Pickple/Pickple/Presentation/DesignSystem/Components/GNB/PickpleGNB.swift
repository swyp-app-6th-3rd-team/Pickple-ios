//
//  PickpleGNB.swift
//  Pickple
//
//  Created by 박윤수 on 8/27/26.
//
// 1차 수정 완료 9월 11일

import SwiftUI

enum PickpleGNBSlotContent {
    case none
    case text(String)
    case image(Image)
    case button(icon: Image, action: () -> Void)
}

struct PickpleGNBSlotView: View {
    let content: PickpleGNBSlotContent

    var body: some View {
        switch content {
        case .none:
            Color.clear.frame(width: 24, height: 24)
        case .text(let text):
            Text(text)
                .pickpleTypography(.title01)
                .foregroundStyle(Color.black)
        case .image(let image):
            image
        case .button(let icon, let action):
            Button(action: action) {
                icon
            }
        }
    }
}

struct PickpleGNB: View {
    let leading: PickpleGNBSlotContent
    let center: PickpleGNBSlotContent
    let trailing: PickpleGNBSlotContent
    // tint는 SF Symbol이나 .renderingMode(.template) 아이콘에만 적용된다.
    // 원본 색이 박힌(.original) 커스텀 에셋은 색이 안 바뀐다.
    var tint: Color = .black
    var background: Color = .clear

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                PickpleGNBSlotView(content: leading)

                Spacer()
                
                PickpleGNBSlotView(content: center)
                
                Spacer()

                PickpleGNBSlotView(content: trailing)
            }
            .frame(maxWidth: .infinity, minHeight: 56)
            .padding(.horizontal, 20)

            Divider()
        }
        .foregroundStyle(tint)
        .background(background)
    }
}

#Preview {
    VStack(spacing: 20) {
        // backGNB: 뒤로가기만, 제목 가운데
        PickpleGNB(
            leading: .button(icon: Image(systemName: "chevron.left"), action: {}),
            center: .text("test"),
            trailing: .none
        )

        // alertGNB: 뒤로가기 + 알림, 제목 좌측
        PickpleGNB(
            leading: .button(icon: Image(systemName: "chevron.left"), action: {}),
            center: .text("test"),
            trailing: .button(icon: Image(systemName: "bell"), action: {})
        )

        // searchGNB: 뒤로가기 + 검색, 제목 좌측
        PickpleGNB(
            leading: .button(icon: Image(systemName: "chevron.left"), action: {}),
            center: .text("Test"),
            trailing: .button(icon: Image(systemName: "magnifyingglass"), action: {})
        )
    }
    .padding()
}
