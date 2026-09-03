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

    // 원들의 가운데를 지나는 연결선이 완료 지점에서 파란색→회색으로 넘어가는 위치(0~1).
    private var progressBoundary: CGFloat {
        guard target > 0 else { return 0 }
        return CGFloat(current) / CGFloat(target)
    }

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 0) {
                ForEach(1...target, id: \.self) { day in
                    dayCircle(day)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 10)
            .background(Capsule().fill(trackGradient))

            HStack(spacing: 0) {
                ForEach(1...target, id: \.self) { day in
                    Text(day == current ? "\(current)일차" : "")
                        .pickpleTypography(.caption)
                        .foregroundStyle(Color.blue60)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }

    private var trackGradient: LinearGradient {
        let blend: CGFloat = 0.03
        return LinearGradient(
            stops: [
                .init(color: .blue60, location: 0),
                .init(color: .blue60, location: max(0, progressBoundary - blend)),
                .init(color: .neutral20, location: min(1, progressBoundary + blend)),
                .init(color: .neutral20, location: 1)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
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
