//
//  PostTypeBadge.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
// 1차 점검 완료 - 9월 12일

import SwiftUI

struct PostTypeBadge: View {
    let type: VoteType
    var iconSize: CGFloat = 16
    var typography: PickpleTypography = .label
    var horizontalPadding: CGFloat = 10
    var verticalPadding: CGFloat = 4
    var textColor: Color = .white
    var backgroundColor: Color = .black
    var stroke: Bool = false
    var strokeColor: Color = .clear

    private var iconName: String {
        switch type {
        case .text: return "PickpleText"
        case .forAgainst: return "PickpleAgainst"
        case .ab: return "PickpleAB"
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            Image(iconName)
                .resizable()
                .frame(width: iconSize, height: iconSize)

            Text(type.displayName)
                .pickpleTypography(typography)
                .foregroundStyle(textColor)
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .background(
            Capsule()
                .foregroundStyle(backgroundColor)
                .overlay {
                    if stroke {
                        Capsule().stroke(strokeColor)
                    }
                }
        )
    }
}

#Preview {
    VStack(spacing: 12) {
        PostTypeBadge(type: .text)
        PostTypeBadge(type: .forAgainst)
        PostTypeBadge(type: .ab, iconSize: 14, typography: .caption, horizontalPadding: 8)
        PostTypeBadge(type: .forAgainst, iconSize: 14, typography: .caption, textColor: .green80, backgroundColor: .green20)
    }
    .padding()
    .background(Color.neutral10)
}
