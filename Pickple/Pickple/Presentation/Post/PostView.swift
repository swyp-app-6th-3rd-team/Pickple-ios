//
//  PostView.swift
//  Pickple
//
//  Created by 박윤수 on 8/29/26.
//

import SwiftUI

// 게시글 작성 플로우 진입점. 진입하자마자 글 유형 선택 바텀시트가 뜨고,
// 유형을 고르면 해당 단계별 작성 화면(PostWriteFlowView)으로 넘어간다.
struct PostView: View {
    @StateObject private var postViewModel = PostViewModel()
    @Environment(\.dismiss) private var dismiss

    @State private var showsTypeSelectionSheet = true
    @State private var navigatesToWriteFlow = false

    var body: some View {
        NavigationStack {
            Color.clear
                .navigationDestination(isPresented: $navigatesToWriteFlow) {
                    PostWriteFlowView(postViewModel: postViewModel)
                }
        }
        .sheet(isPresented: $showsTypeSelectionSheet, onDismiss: {
            // 유형을 고르지 않고 시트만 닫으면 작성 자체를 취소한다.
            if !navigatesToWriteFlow {
                dismiss()
            }
        }) {
            PostTypeSelectionSheet { type in
                postViewModel.selectedType = type
                navigatesToWriteFlow = true
                showsTypeSelectionSheet = false
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    PostView()
}
