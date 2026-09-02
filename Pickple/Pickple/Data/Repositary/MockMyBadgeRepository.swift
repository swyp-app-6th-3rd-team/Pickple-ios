//
//  MockMyBadgeRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 잠금 뱃지(PICK 개근/PICK 중독) 해금 조건 문구는 임시값 — 디자인/기획 확정 후 수정
//
import Foundation

struct MockMyBadgeRepository: MyBadgeRepository {
    func fetchMyBadges() async -> [MyBadge] {
        [
            MyBadge(
                id: UUID(),
                title: "첫 PICK",
                iconOnName: "PickpleBadgeFirstPickOn",
                iconOffName: "PickpleBadgeFirstPickOff",
                isUnlocked: true,
                unlockCondition: "이 뱃지를 해제하려면\n누적 투표 10회를 달성하세요."
            ),
            MyBadge(
                id: UUID(),
                title: "PICK 새싹",
                iconOnName: "PickpleBadgeSproutOn",
                iconOffName: "PickpleBadgeSproutOff",
                isUnlocked: true,
                unlockCondition: "이 뱃지를 해제하려면\n누적 투표 10회를 달성하세요."
            ),
            MyBadge(
                id: UUID(),
                title: "PICK 프로",
                iconOnName: "PickpleBadgeProOn",
                iconOffName: "PickpleBadgeProOff",
                isUnlocked: true,
                unlockCondition: "이 뱃지를 해제하려면\n누적 투표 50회를 달성하세요."
            ),
            MyBadge(
                id: UUID(),
                title: "PICK 마스터",
                iconOnName: "PickpleBadgeMasterOn",
                iconOffName: "PickpleBadgeMasterOff",
                isUnlocked: true,
                unlockCondition: "이 뱃지를 해제하려면\n누적 투표 100회를 달성하세요."
            ),
            MyBadge(
                id: UUID(),
                title: "PICK 헌터",
                iconOnName: "PickpleBadgeHunterOn",
                iconOffName: "PickpleBadgeHunterOff",
                isUnlocked: true,
                unlockCondition: "이 뱃지를 해제하려면\n댓글 50회를 달성하세요."
            ),
            MyBadge(
                id: UUID(),
                title: "PICK 폭주",
                iconOnName: "PickpleBadgeRampageOn",
                iconOffName: "PickpleBadgeRampageOff",
                isUnlocked: true,
                unlockCondition: "이 뱃지를 해제하려면\n하루 투표 20회를 달성하세요."
            ),
            MyBadge(
                id: UUID(),
                title: "PICK 개근",
                iconOnName: "PickpleBadgeAttendanceOn",
                iconOffName: "PickpleBadgeAttendanceOff",
                isUnlocked: false,
                unlockCondition: "이 뱃지를 해제하려면\n7일 연속 출석하세요."
            ),
            MyBadge(
                id: UUID(),
                title: "PICK 중독",
                iconOnName: "PickpleBadgeAddictOn",
                iconOffName: "PickpleBadgeAddictOff",
                isUnlocked: false,
                unlockCondition: "이 뱃지를 해제하려면\n누적 투표 500회를 달성하세요."
            ),
        ]
    }
}
