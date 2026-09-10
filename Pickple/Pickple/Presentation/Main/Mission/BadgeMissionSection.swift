//
//  BadgeMissionSection.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 요일별 진행 표시 색상·굵기는 임시값

import SwiftUI

struct BadgeMissionSection: View {
    let isLoggedIn: Bool
    let missions: [BadgeMissionProgress]
    @Binding var isExpanded: Bool
    var onLoginTapped: () -> Void = {}

    // 미션1(누적)·미션2(일일+연속) 중 어느 쪽이든 완료하면 그날 치가 끝난다 — 두 계열에서
    // 각각 완료된 단계 수(계열이 목록에서 빠졌으면 4단계 전부 완료로 침)를 합쳐서 며칠차인지
    // 정한다. 최대 3+3(완료)+1(진행중) = 7이라 트래커의 7칸과 정확히 맞아떨어진다.
    private var missionDay: Int {
        func completedCount(cumulative: Bool) -> Int {
            if let active = missions.first(where: { $0.iconFamily.isCumulativeFamily == cumulative }) {
                return active.iconFamily.ladderPosition - 1
            }
            return 4
        }
        return min(completedCount(cumulative: true) + completedCount(cumulative: false) + 1, 7)
    }

    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.spring()) { isExpanded.toggle() }
            } label: {
                HStack(spacing: 8) {
                    Image("PickpleBadgeSproutOn")
                        .resizable()
                        .frame(width: 48, height: 48)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(MainStrings.badgeMissionTitle)
                            .pickpleTypography(.body01)
                            .foregroundStyle(Color.neutral100)

                        Text(isLoggedIn ? MainStrings.badgeMissionSubtitleLoggedIn : MainStrings.badgeMissionSubtitleGuest)
                            .pickpleTypography(.caption)
                            .foregroundStyle(Color.blue60)
                    }

                    Spacer()

                    Image(systemName: "chevron.down")
                        .foregroundStyle(Color.neutral40)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(16)
            }

            if isExpanded {
                if isLoggedIn {
                    VStack(spacing: 12) {
                        ForEach(missions) { mission in
                            BadgeMissionProgressRow(mission: mission)
                        }

                        // 미션1·미션2 둘 다 매일 채워야 하는 게 아니라, 둘 중 하나를 완료해도
                        // 그날 치가 끝난다 — 두 계열에서 각각 완료된 단계 수(최대 3+3)를 합쳐서
                        // 며칠차인지 정한다. 한 계열이 다 채워져서 목록에서 빠졌으면(§완료) 그
                        // 계열은 4단계 전부 완료로 센다.
                        BadgeMissionStreakTracker(current: missionDay, target: 7)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                } else {
                    Button(action: onLoginTapped) {
                        Text(MainStrings.badgeMissionSubtitleGuest)
                            .pickpleTypography(.body01)
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(RoundedRectangle(cornerRadius: 8).foregroundStyle(Color.neutral100))
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.navy10, lineWidth: 1)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var isExpanded = true
        @State private var isGuestExpanded = true

        var body: some View {
            VStack(spacing: 16) {
                BadgeMissionSection(
                    isLoggedIn: true,
                    missions: [
                        BadgeMissionProgress(id: UUID(), title: "누적 투표 1,000회 달성", badgeIconOffName: "PickpleBadgeMasterOff", iconFamily: .master, current: 0, target: 1000),
                        BadgeMissionProgress(id: UUID(), title: "7일 연속 매일 투표 참여", badgeIconOffName: "PickpleBadgeAttendanceOff", iconFamily: .attendance, current: 2, target: 7)
                    ],
                    isExpanded: $isExpanded
                )

                BadgeMissionSection(
                    isLoggedIn: false,
                    missions: [],
                    isExpanded: $isGuestExpanded,
                    onLoginTapped: {}
                )
            }
            .padding()
        }
    }
    return PreviewWrapper()
}
