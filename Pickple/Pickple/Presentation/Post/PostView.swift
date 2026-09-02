//
//  PostView.swift
//  Pickple
//
//  Created by 박윤수 on 8/29/26.
//

import SwiftUI

// 게시글 작성 플로우 진입점. 유형 선택(PostTypeSelectionView) → 단계별 작성(PostWriteFlowView) 순으로 이동한다.
struct PostView: View {
    @StateObject private var postViewModel = PostViewModel()

    var body: some View {
        NavigationStack {
            PostTypeSelectionView(postViewModel: postViewModel)
        }
    }
}

#Preview {
    PostView()
}
