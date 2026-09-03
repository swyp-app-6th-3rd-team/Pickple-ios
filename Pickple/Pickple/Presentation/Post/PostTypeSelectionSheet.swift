//
//  PostTypeSelectionSheet.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 여백/시트 높이는 임시값

import SwiftUI

// 게시글 작성 진입 시 뜨는 글 유형 선택 바텀시트. 행을 탭하면 바로 해당 유형으로 진행한다.
struct PostTypeSelectionSheet: View {
    let onSelect: (VoteType) -> Void

    var body: some View {
        VStack(spacing: 0) {
            PostTypeRow(icon: "PickpleAgainst", title: PostViewStrings.forAgainstPickRowTitle) { onSelect(.forAgainst) }
            PostTypeRow(icon: "PickpleAB", title: PostViewStrings.abPickRowTitle) { onSelect(.ab) }
            PostTypeRow(icon: "PickpleText", title: PostViewStrings.textPickRowTitle) { onSelect(.text) }
        }
        .padding(.horizontal, 4)
        .presentationDetents([.height(260)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            PostTypeSelectionSheet(onSelect: { _ in })
        }
}
