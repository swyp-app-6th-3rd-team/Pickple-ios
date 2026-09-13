//
//  BadgeMissionSection.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료 - 9월 12일
// 폰트 확인 필요
// 일일 미션 재정비 필요

import SwiftUI

struct BadgeMissionSection: View {
    let isLoggedIn: Bool
    let missions: [BadgeMissionProgress]
    @Binding var isExpanded: Bool
    var onLoginTapped: () -> Void = {}

    // 미션1(누적)·미션2(일일+연속) 중 어느 쪽이든 완료하면 그날 치가 끝난다 — 두 계열에서

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
        VStack(spacing: 4) {
            Button {
                withAnimation(.spring()) { isExpanded.toggle() }
            } label: {
                HStack(spacing: 8) {
                    //표시 뱃지는 미정 일단 기본 뱃지로 고정
                    Image("PickpleBadgeSproutOn")
                        .resizable()
                        .frame(width: 48, height: 48)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(MainStrings.badgeMissionTitle)
                            .pickpleTypography(.body01)
                            .foregroundStyle(Color.black)

                        Text(isLoggedIn ? MainStrings.badgeMissionSubtitleLoggedIn : MainStrings.badgeMissionSubtitleGuest)
                            .pickpleTypography(.caption) //폰트 미지정 임시 적용
                            .foregroundStyle(Color.blue60)
                    }

                    Spacer()

                    Image("PickpleArrowUp")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.neutral40)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(16)
            }

            if isExpanded {
                if isLoggedIn {
                    VStack(spacing: 8) {
                        // 일일 미션 재정비 필요

                        ForEach(missions) { mission in
                            BadgeMissionProgressRow(mission: mission)
                        }
                        BadgeMissionStreakTracker(current: missionDay, target: 7)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                } else {
                    Button(action: onLoginTapped) {
                        Text(MainStrings.badgeMissionSubtitleGuest)
                            .pickpleTypography(.body01)
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(RoundedRectangle(cornerRadius: 8).foregroundStyle(Color.black))
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
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
