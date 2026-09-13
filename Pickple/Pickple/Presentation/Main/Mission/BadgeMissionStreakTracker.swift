//
//  BadgeMissionStreakTracker.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료 - 9월 12일
// 그라데이션 효과 다일치 디자인 필요

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
                    if day != target {
                        Spacer(minLength: 0)
                    }
                }
            }
            .background(Capsule().fill(trackGradient))

            HStack(spacing: 0) {
                ForEach(1...target, id: \.self) { day in
                    Text(day == current ? "\(current)일차" : "")
                        .pickpleTypography(.caption)
                        .foregroundStyle(Color.blue60)
                    if day != target {
                        Spacer()
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.35), value: current)
    }

    // 완료 구간(파랑) → 오늘 구간(그라데이션) → 이후 구간(트랙 배경) 순으로 이어지는 연결선.
    // TODO: 트랙 배경(F6F8FA)과 오늘 구간 그라데이션 색(0xACD3FF, 0xD7E9FF)이 에셋에 없어 하드코딩/근접값으로 대체함. 정확한 컬러셋 추가되면 교체.
    private var trackGradient: LinearGradient {
        guard target > 1 else {
            return LinearGradient(colors: [.neutral5], startPoint: .leading, endPoint: .trailing)
        }

        let segmentWidth = 1 / CGFloat(target - 1)
        // current가 1(스트릭 첫날)이면 todayStart가 음수가 되어 첫 stop(location: 0)보다
        // 앞서면서 그라데이션 stop 순서가 역전된다. 0...1로 clamp해서 항상 오름차순을 보장한다.
        let todayStart = max(0, min(1, CGFloat(current - 2) * segmentWidth))
        let todayEnd = max(todayStart, min(1, CGFloat(current - 1) * segmentWidth))

        return LinearGradient(
            stops: [
                .init(color: .blue60, location: 0),
                .init(color: Color(red: 0xAC / 255, green: 0xD3 / 255, blue: 0xFF / 255), location: todayStart),
                .init(color: Color(red: 0xD7 / 255, green: 0xE9 / 255, blue: 0xFF / 255).opacity(0), location: todayEnd),
                .init(color: .neutral5, location: todayEnd),
                .init(color: .neutral5, location: 1)
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
            .contentTransition(.opacity)
    }
}

#Preview {
    BadgeMissionStreakTracker(current: 2, target: 7)
        .padding()
}
