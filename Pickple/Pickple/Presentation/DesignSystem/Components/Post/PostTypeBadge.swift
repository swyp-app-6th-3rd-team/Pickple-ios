//
//  PostTypeBadge.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  게시글 카드들이 각자 구현하던 "유형 아이콘 + 이름 + 검은 캡슐 배경" 배지를 공용화했다.
//  이미지 위에 겹쳐 그리는 카드는 호출부에서 .padding(...)으로 가장자리 여백을 더해서 쓴다.

import SwiftUI

struct PostTypeBadge: View {
    let type: VoteType
    var iconSize: CGFloat = 16
    var typography: PickpleTypography = .label
    var horizontalPadding: CGFloat = 10
    var verticalPadding: CGFloat = 4
    var textColor: Color = .white
    var backgroundColor: Color = .black

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
        .background(Capsule().foregroundStyle(backgroundColor))
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
