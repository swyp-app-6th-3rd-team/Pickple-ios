//
//  PickpleGNB.swift
//  Pickple
//
//  Created by 박윤수 on 8/27/26.
//
//  TODO: 디자인 확정 후 변경 필요
//  - 폰트: Text에 폰트 적용 필요 (현재 시스템 기본 폰트)
//  - 색상: Color 하드코딩 → Asset Catalog 컬러셋으로 교체
//

import SwiftUI

enum PickpleGNBSlotContent {
    case none
    case text(String)
    case button(icon: Image, action: () -> Void)
}

struct PickpleGNBSlotView: View {
    let content: PickpleGNBSlotContent

    var body: some View {
        switch content {
        case .none:
            Color.clear.frame(width: 24)
        case .text(let text):
            Text(text)
        case .button(let icon, let action):
            Button(action: action) {
                icon
                    .foregroundStyle(Color.black)
            }
        }
    }
}

struct PickpleGNB: View {
    let leading: PickpleGNBSlotContent
    let center: PickpleGNBSlotContent
    let trailing: PickpleGNBSlotContent

    var body: some View {
        VStack {
            HStack {
                PickpleGNBSlotView(content: leading)
                    .padding(.leading, 20)

                Spacer()
                PickpleGNBSlotView(content: center)
                Spacer()

                PickpleGNBSlotView(content: trailing)
                    .padding(.trailing, 20)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        // backGNB: 뒤로가기만, 제목 가운데
        PickpleGNB(
            leading: .button(icon: Image(systemName: "chevron.left"), action: {}),
            center: .text(GNBStrings.backTitle),
            trailing: .none
        )

        // alertGNB: 뒤로가기 + 알림, 제목 좌측
        PickpleGNB(
            leading: .button(icon: Image(systemName: "chevron.left"), action: {}),
            center: .text(GNBStrings.alertTitle),
            trailing: .button(icon: Image(systemName: "bell"), action: {})
        )

        // searchGNB: 뒤로가기 + 검색, 제목 좌측
        PickpleGNB(
            leading: .button(icon: Image(systemName: "chevron.left"), action: {}),
            center: .text(GNBStrings.searchTitle),
            trailing: .button(icon: Image(systemName: "magnifyingglass"), action: {})
        )
    }
    .padding()
}
