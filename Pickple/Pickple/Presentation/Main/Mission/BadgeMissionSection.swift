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

                        if let streakMission = missions.first(where: { $0.iconFamily.isStreakType }) {
                            BadgeMissionStreakTracker(current: streakMission.current, target: streakMission.target)
                        }
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
