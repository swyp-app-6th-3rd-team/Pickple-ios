//
//  MyPageStatusView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//
// 1차 점검 완료 - 9월 13일

import SwiftUI

struct MyPageStatusView: View {
    let myPageViewModel: MyPageViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            MyPageStatsView(myPageViewModel: myPageViewModel)
            
            MyPagePointsView(myPageViewModel: myPageViewModel)
            
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity) //Fill
        .background(
            UnevenRoundedRectangle(
            topLeadingRadius: 24,
            topTrailingRadius: 24
            )
            .foregroundStyle(Color.white)
        )
        
    }
}

#Preview {
    MyPageStatusView(myPageViewModel: MyPageViewModel())
}
