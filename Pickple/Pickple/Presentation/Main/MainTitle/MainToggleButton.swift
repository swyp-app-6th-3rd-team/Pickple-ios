//
//  MainToggleButton.swift
//  Pickple
//
//  Created by 박윤수 on 9/5/26.
//

import SwiftUI

struct MainToggleButton: View {
    @Binding var isOn: Bool
    let onTitle: String
    let offTitle: String

    private let width: CGFloat = 95
    private let height: CGFloat = 32

    var body: some View {
        ZStack(alignment: isOn ? .trailing : .leading) {
            Capsule()
                .foregroundStyle(Color.neutral5)
                .frame(width: 95, height: 32)

            // 선택된 쪽으로 미끄러지듯 이동하는 검정 캡슐
            Capsule()
                .foregroundStyle(Color.neutral100)
                .frame(width: width / 2)
                .padding(2)

            HStack(spacing: 0) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { isOn = false }
                } label: {
                    Text(offTitle)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(isOn ? Color.neutral20 : Color.green60)
                }

                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { isOn = true }
                } label: {
                    Text(onTitle)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(isOn ? Color.green60 : Color.neutral20)
                }
            }
            .pickpleTypography(.body02)
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    @Previewable @State var isOn = false
    MainToggleButton(isOn: $isOn, onTitle: "찬반", offTitle: "AB")
}
