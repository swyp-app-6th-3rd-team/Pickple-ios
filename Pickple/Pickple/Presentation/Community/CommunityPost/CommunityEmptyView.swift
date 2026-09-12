//
//  CommunityEmptyView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료 - 9월 12일

import SwiftUI

struct CommunityEmptyView: View {
    var body: some View {
        VStack(spacing: 30) {
            Image("PickplePost")
                .resizable()
                .frame(width: 100, height: 100)
                .shadow(color: Color.black.opacity(0.3), radius: 4)
            
            Text(CommunityStrings.emptyMessage)
                .pickpleTypography(.title02)
                .foregroundStyle(Color.neutral30)
        }
    }
}

#Preview {
    CommunityEmptyView()
}
