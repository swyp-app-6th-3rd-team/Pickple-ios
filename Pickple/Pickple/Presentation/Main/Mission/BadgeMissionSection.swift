//
//  BadgeMissionSection.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 뱃지 아이콘은 임시 시스템 아이콘(전용 에셋 없음)

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
                    Image(systemName: "shield.fill")
                        .foregroundStyle(Color.yellow60)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("뱃지 획득 미션")
                            .pickpleTypography(.body01)
                            .foregroundStyle(Color.neutral100)

                        Text(isLoggedIn ? "뱃지 획득을 위해 미션을 완료해보세요" : "로그인하고 뱃지를 획득해보세요")
                            .pickpleTypography(.caption)
                            .foregroundStyle(Color.neutral40)
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
                    ForEach(missions) { mission in
                        BadgeMissionProgressRow(mission: mission)
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

private struct BadgeMissionProgressRow: View {
    let mission: BadgeMissionProgress

    var body: some View {
        HStack {
            Text(mission.title)
                .pickpleTypography(.body02)
                .foregroundStyle(Color.neutral70)

            Spacer()

            Text("\(mission.current)/\(mission.target)")
                .pickpleTypography(.body02)
                .foregroundStyle(Color.neutral40)
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
                    BadgeMissionProgress(id: UUID(), title: "누적 투표 1,000회 달성", current: 0, target: 1000),
                    BadgeMissionProgress(id: UUID(), title: "7일 연속 매일 투표 참여", current: 2, target: 7)
                ],
                isExpanded: $isExpanded
            )
            .padding()
        }
    }
    return PreviewWrapper()
}
