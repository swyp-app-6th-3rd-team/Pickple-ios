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
    @State private var postViewModel = PostViewModel()
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
        // PostWriteFlowView에서 뒤로가기로 나오면(= 작성 포기) navigatesToWriteFlow가 다시 false가 되는데,
        // 유형 선택 시트를 다시 띄우지 않고 작성 플로우 전체를 닫는다. 안 그러면 NavigationStack의
        // 루트인 빈 Color.clear만 남아 화면이 막다른 상태가 된다.
        .onChange(of: navigatesToWriteFlow) { _, newValue in
            if !newValue {
                dismiss()
            }
        }
    }
}

#Preview {
    PostView()
}
