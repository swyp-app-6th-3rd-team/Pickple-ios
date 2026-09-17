//
//  PostDetailCommentEmptyView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료 - 9월 12일

import SwiftUI

struct PostDetailCommentEmptyView: View {
    var body: some View {
        VStack {
            
            Text(PostDetailStrings.commentEmptyMessage)
                .pickpleTypography(.title02_600)
                .foregroundStyle(Color.neutral30)
                .padding(.top, 106)
                .padding(.bottom, 189)
                
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    PostDetailCommentEmptyView()
}
