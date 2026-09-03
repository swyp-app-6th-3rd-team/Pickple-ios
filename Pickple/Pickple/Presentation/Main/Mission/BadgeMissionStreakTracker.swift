//
//  BadgeMissionStreakTracker.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

import SwiftUI

// "N일 연속" 미션 전용 요일별 진행 표시. 마지막 칸(보상 지급일)은 Last 아이콘으로 표시한다.
struct BadgeMissionStreakTracker: View {
    let current: Int
    let target: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...target, id: \.self) { day in
                dayView(day)
            }
        }
        .padding(.vertical, 10)
        .background(Capsule().fill(Color.neutral5))
    }

    private func dayView(_ day: Int) -> some View {
        let imageName: String
        if day == target {
            imageName = "Property 1=Last"
        } else if day < current {
            imageName = "Property 1=Check"
        } else if day == current {
            imageName = "Property 1=Today"
        } else {
            imageName = "Property 1=Disable"
        }

        return VStack(spacing: 4) {
            Image(imageName)
                .resizable()
                .frame(width: 24, height: 24)

            Text(day == current ? "\(current)일차" : "")
                .pickpleTypography(.caption)
                .foregroundStyle(Color.blue60)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    BadgeMissionStreakTracker(current: 2, target: 7)
        .padding()
}
