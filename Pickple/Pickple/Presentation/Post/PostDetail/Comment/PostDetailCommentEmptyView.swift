//
//  PostDetailCommentEmptyView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

struct PostDetailCommentEmptyView: View {
    var body: some View {
        VStack {
            Spacer(minLength: 80)
            Text(PostDetailStrings.commentEmptyMessage)
                .pickpleTypography(.body01)
                .foregroundStyle(Color.neutral40)
            Spacer(minLength: 80)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    PostDetailCommentEmptyView()
}
