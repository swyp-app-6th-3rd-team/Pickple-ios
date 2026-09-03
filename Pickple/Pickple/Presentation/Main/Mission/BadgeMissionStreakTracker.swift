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
        VStack(spacing: 4) {
            HStack(spacing: 0) {
                ForEach(1...target, id: \.self) { day in
                    dayCircle(day)
                        .frame(maxWidth: .infinity)

                    if day != target {
                        connector(after: day)
                    }
                }
            }
            .padding(.vertical, 10)
            .background(Capsule().fill(Color.neutral5))

            HStack(spacing: 0) {
                ForEach(1...target, id: \.self) { day in
                    Text(day == current ? "\(current)일차" : "")
                        .pickpleTypography(.caption)
                        .foregroundStyle(Color.blue60)
                        .frame(maxWidth: .infinity)

                    if day != target {
                        Color.clear.frame(width: 8)
                    }
                }
            }
        }
    }

    // 완료된 날짜와 다음 날짜 사이를 잇는 선. 오늘(current)에서 다음 날로 넘어가는 구간만
    // 파란색에서 회색으로 그라데이션을 줘서 "여기서부터 아직 안 했다"는 걸 표현한다.
    private func connector(after day: Int) -> some View {
        Group {
            if day < current {
                Color.blue60
            } else if day == current {
                LinearGradient(colors: [Color.blue60, Color.neutral20], startPoint: .leading, endPoint: .trailing)
            } else {
                Color.neutral20
            }
        }
        .frame(width: 8, height: 2)
    }

    private func dayCircle(_ day: Int) -> some View {
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

        return Image(imageName)
            .resizable()
            .frame(width: 24, height: 24)
    }
}

#Preview {
    BadgeMissionStreakTracker(current: 2, target: 7)
        .padding()
}
