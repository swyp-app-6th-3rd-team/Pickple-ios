//
//  MyPagePointsView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//

import SwiftUI

struct MyPagePointsView: View {
    @ObservedObject var myPageViewModel: MyPageViewModel
    
    private var currentPoints: Int? {
        myPageViewModel.userInfo?.points
    }
    
    var body: some View {
        //XMARK: - Points
        VStack(spacing: 0) {
            //XMARK: - PointsTOP
            ZStack {
                HStack {
                    HStack(spacing: 4) {
                        Image("PickplePoint")
                            .frame(width: 20, height: 20)
                        
                        Text("현재 보유 포인트")
                            .pickpleTypography(.body02)
                            .foregroundStyle(Color.white)
                    }
                    
                    Spacer()
                    
                    if let point = myPageViewModel.userInfo?.points {
                        Text("\(point)")
                            .pickpleTypography(.body02)
                            .foregroundStyle(Color.white)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 8,
                        topTrailingRadius: 8
                    )
                    .foregroundStyle(Color.navy60)
                )
                
            }
            .frame(maxWidth: .infinity)
            
            //XMARK: - PointsBottom
            VStack(spacing: 8) {
                    //MARK: - Level
                HStack {
                    HStack(spacing: 8) {
                        Image("PickpleBadge1")
                        
                        if let level = myPageViewModel.userInfo?.level {
                            Text("LV. \(level)")
                                .foregroundStyle(Color.neutral100)
                        }
                    }
                        
                        Spacer()
                        
                    //XMARK: - NextLevel
                        if let nextLevel = myPageViewModel.userInfo?.pointsToNextLevel {
                            HStack(spacing: 3) {
                                Text("다음 레벨까지")
                                    .pickpleTypography(.label)
                                
                                Text("\(nextLevel)P")
                                    .pickpleTypography(.body02)
                            }
                            .foregroundStyle(Color.neutral70)
                            
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 14)
                    //XMARK: - ProgressBar
                    if let nextLevel = myPageViewModel.userInfo?.pointsToNextLevel,
                       let current = currentPoints {
                        ProgressView(value: Double(current), total: Double(current + nextLevel))
                            .progressViewStyle(LinearProgressViewStyle(tint: Color.green60))
                            .padding(.horizontal, 16)
                            .padding(.bottom, 14)
                            .frame(maxWidth: .infinity, minHeight: 8, maxHeight: 8)
                    }
                }
                .background(
                    UnevenRoundedRectangle(
                        bottomLeadingRadius: 8,
                        bottomTrailingRadius: 8
                    )
                    .foregroundStyle(Color.white)
                    .overlay {
                        UnevenRoundedRectangle(
                            bottomLeadingRadius: 8,
                            bottomTrailingRadius: 8
                        )
                        .strokeBorder(Color.navy60)
                        
                    }
                )
                .frame(maxWidth: .infinity)
        }
        .frame(width: 353)
    }
}

#Preview {
    MyPageView(myPageViewModel: MyPageViewModel())
}
