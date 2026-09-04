//
//  MockMyBadgeRepository.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 뱃지 명칭은 "추후 수정" 전제로 받은 값 — 최종 확정 전까지 참고용
//
import Foundation

struct MockMyBadgeRepository: MyBadgeRepository {
    func fetchMyBadges() async -> [MyBadge] {
        [
            MyBadge(
                id: UUID(),
                title: "투표 꿈나무",
                iconOnName: "PickpleBadgeFirstPickOn",
                iconOffName: "PickpleBadgeFirstPickOff",
                isUnlocked: true,
                isNewlyUnlocked: false,
                unlockCondition: "이 뱃지를 해제하려면\n누적 투표 10회를 달성하세요."
            ),
            MyBadge(
                id: UUID(),
                title: "결정 해결사",
                iconOnName: "PickpleBadgeSproutOn",
                iconOffName: "PickpleBadgeSproutOff",
                isUnlocked: true,
                isNewlyUnlocked: false,
                unlockCondition: "이 뱃지를 해제하려면\n누적 투표 100회를 달성하세요."
            ),
            MyBadge(
                id: UUID(),
                title: "프로 참견러",
                iconOnName: "PickpleBadgeProOn",
                iconOffName: "PickpleBadgeProOff",
                isUnlocked: true,
                isNewlyUnlocked: false,
                unlockCondition: "이 뱃지를 해제하려면\n누적 투표 500회를 달성하세요."
            ),
            MyBadge(
                id: UUID(),
                title: "천표 보유자",
                iconOnName: "PickpleBadgeMasterOn",
                iconOffName: "PickpleBadgeMasterOff",
                isUnlocked: true,
                isNewlyUnlocked: false,
                unlockCondition: "이 뱃지를 해제하려면\n누적 투표 1,000회를 달성하세요."
            ),
            MyBadge(
                id: UUID(),
                title: "투표 헌터",
                iconOnName: "PickpleBadgeHunterOn",
                iconOffName: "PickpleBadgeHunterOff",
                isUnlocked: true,
                isNewlyUnlocked: false,
                unlockCondition: "이 뱃지를 해제하려면\n하루에 투표 20개 이상 참여하세요."
            ),
            MyBadge(
                id: UUID(),
                title: "투표 폭주기관차",
                iconOnName: "PickpleBadgeRampageOn",
                iconOffName: "PickpleBadgeRampageOff",
                isUnlocked: true,
                isNewlyUnlocked: true,
                unlockCondition: "이 뱃지를 해제하려면\n하루에 투표 30개 이상 참여하세요."
            ),
            MyBadge(
                id: UUID(),
                title: "성실한 유권자",
                iconOnName: "PickpleBadgeAttendanceOn",
                iconOffName: "PickpleBadgeAttendanceOff",
                isUnlocked: false,
                isNewlyUnlocked: false,
                unlockCondition: "이 뱃지를 해제하려면\n7일 연속 매일 투표에 참여하세요."
            ),
            MyBadge(
                id: UUID(),
                title: "투표 중독자",
                iconOnName: "PickpleBadgeAddictOn",
                iconOffName: "PickpleBadgeAddictOff",
                isUnlocked: false,
                isNewlyUnlocked: false,
                unlockCondition: "이 뱃지를 해제하려면\n30일 연속 매일 투표에 참여하세요."
            ),
        ]
    }
}
