//
//  BadgeMissionSection.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 요일별 진행 표시/진행률 막대 색상·굵기는 임시값

import SwiftUI

struct BadgeMissionSection: View {
    let isLoggedIn: Bool
    let missions: [BadgeMissionProgress]
    @Binding var isExpanded: Bool

    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.spring()) { isExpanded.toggle() }
            } label: {
                HStack(spacing: 8) {
                    if let firstMissionBadge = missions.first?.badgeIconOffName {
                        Image(firstMissionBadge)
                            .resizable()
                            .frame(width: 48, height: 48)
                    } else {
                        Image("PickpleMyBadge")
                            .resizable()
                            .frame(width: 48, height: 48)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("뱃지 획득 미션")
                            .pickpleTypography(.body01)
                            .foregroundStyle(Color.neutral100)

                        Text(isLoggedIn ? "뱃지 획득을 위해 미션을 완료해보세요" : "로그인하고 뱃지를 획득해보세요")
                            .pickpleTypography(.caption)
                            .foregroundStyle(Color.blue60)
                    }

                    Spacer()

                    if isLoggedIn {
                        Image(systemName: "chevron.down")
                            .foregroundStyle(Color.neutral40)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }
                }
                .padding(16)
            }
            .disabled(!isLoggedIn)

            if isLoggedIn && isExpanded {
                VStack(spacing: 12) {

                    if let streakMission = missions.first(where: { $0.title.contains("연속") }) {
                        BadgeMissionStreakTracker(current: streakMission.current, target: streakMission.target)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
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

        var body: some View {
            BadgeMissionSection(
                isLoggedIn: true,
                missions: [
                    BadgeMissionProgress(id: UUID(), title: "누적 투표 1,000회 달성", badgeIconOffName: "PickpleBadgeMasterOff", current: 0, target: 1000),
                    BadgeMissionProgress(id: UUID(), title: "7일 연속 매일 투표 참여", badgeIconOffName: "PickpleBadgeAttendanceOff", current: 2, target: 7)
                ],
                isExpanded: $isExpanded
            )
            .padding()
        }
    }
    return PreviewWrapper()
}
