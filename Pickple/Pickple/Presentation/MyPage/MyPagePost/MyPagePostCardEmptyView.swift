//
//  MyPagePostCardEmptyView.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//

import SwiftUI

struct MyPagePostCardEmptyView: View {
    var body: some View {
        Button(action: {}) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 160, height: 238) //Fixed
                    .foregroundStyle(Color.neutral5)
                
                VStack {
                    ZStack {
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(Color.white)
                        Image("PickplePlus")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.neutral30)
                    }
                    Text("새 투표 올리기")
                        .pickpleTypography(.body02)
                        .foregroundStyle(Color.neutral40)
                }
            }
        }
    }
}


#Preview {
    MyPagePostCardEmptyView()
}
