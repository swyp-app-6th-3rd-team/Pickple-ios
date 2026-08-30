//
//  PickpleSelectionButton.swift
//  Pickple
//
//  Created by 박윤수 on 8/29/26.
//

import SwiftUI

struct PickpleSelectionButton: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .pickpleTypography(.body01)
            .foregroundStyle(isSelected ? Color.white : Color.black)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(isSelected ? Color.black : Color.navy10)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// 다른 파일에서 .pickpleSelection(isSelected:) 형태로 쓰려면
extension ButtonStyle where Self == PickpleSelectionButton {
    static func pickpleSelection(isSelected: Bool) -> PickpleSelectionButton {
        PickpleSelectionButton(isSelected: isSelected)
    }
}

#Preview {
    VStack(spacing: 12) {
        HStack(spacing: 12) {
            Button("찬반 픽") {}
                .buttonStyle(.pickpleSelection(isSelected: true))
            Button("비교 픽") {}
                .buttonStyle(.pickpleSelection(isSelected: false))
        }
    }
    .padding()
}
