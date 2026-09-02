//
//  CommunityEmptyView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

struct CommunityEmptyView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image("PickpleNote")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundStyle(Color.neutral20)

            Text("아직 작성된 게시글이 없어요")
                .pickpleTypography(.body01)
                .foregroundStyle(Color.neutral40)
        }
    }
}

#Preview {
    CommunityEmptyView()
}
