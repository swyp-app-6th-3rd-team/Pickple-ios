//
//  MyPagePointsView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//

import SwiftUI

struct MyPagePointsView: View {
    let myPageViewModel: MyPageViewModel

    private var currentPoints: Int? {
        myPageViewModel.userInfo?.points
    }

    var body: some View {
        VStack(spacing: 0) {
            MyPagePointsHeaderRow(points: myPageViewModel.userInfo?.points)
            MyPagePointsLevelFooter(
                level: myPageViewModel.userInfo?.level,
                pointsToNextLevel: myPageViewModel.userInfo?.pointsToNextLevel,
                currentPoints: currentPoints
            )
        }
        .frame(width: 353) //Fixed
    }
}

// 포인트 카드 상단 — 네이비 배경의 "현재 포인트" 바.
private struct MyPagePointsHeaderRow: View {
    let points: Int?

    var body: some View {
        HStack {
            HStack(spacing: 4) {
                Image("PickplePoint")
                    .resizable()
                    .frame(width: 20, height: 20)

                Text(MyPageStrings.currentPoints)
                    .pickpleTypography(.body02)
                    .foregroundStyle(Color.white)
            }

            Spacer()

            if let points {
                Text("\(points)")
                    .pickpleTypography(.body02)
                    .foregroundStyle(Color.white)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            UnevenRoundedRectangle(topLeadingRadius: 8, topTrailingRadius: 8)
                .foregroundStyle(Color.navy60)
        )
        .frame(maxWidth: .infinity)
    }
}

// 포인트 카드 하단 — 흰 배경의 레벨 뱃지 + 다음 레벨까지 필요한 포인트 + 진행률 바.
private struct MyPagePointsLevelFooter: View {
    let level: Int?
    let pointsToNextLevel: Int?
    let currentPoints: Int?

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                HStack(spacing: 8) {
                    Image("PickpleBadge1")

                    if let level {
                        Text("LV. \(level)")
                            .foregroundStyle(Color.neutral100)
                    }
                }

                Spacer()

                if let pointsToNextLevel {
                    HStack(spacing: 3) {
                        Text(MyPageStrings.nextLevel)
                            .pickpleTypography(.label)

                        Text("\(pointsToNextLevel)P")
                            .pickpleTypography(.body02)
                    }
                    .foregroundStyle(Color.neutral70)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)

            if let pointsToNextLevel, let currentPoints {
                ProgressView(value: Double(currentPoints), total: Double(currentPoints + pointsToNextLevel))
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.green60))
                    .padding(.horizontal, 16)
                    .padding(.bottom, 14)
                    .frame(maxWidth: .infinity, minHeight: 8, maxHeight: 8)
            }
        }
        .background(
            UnevenRoundedRectangle(bottomLeadingRadius: 8, bottomTrailingRadius: 8)
                .foregroundStyle(Color.white)
                .overlay {
                    UnevenRoundedRectangle(bottomLeadingRadius: 8, bottomTrailingRadius: 8)
                        .strokeBorder(Color.navy60)
                }
        )
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MyPageView(myPageViewModel: MyPageViewModel())
}
