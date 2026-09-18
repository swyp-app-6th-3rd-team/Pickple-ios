//
//  MyBadgeViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Foundation

@Observable
class MyBadgeViewModel {
    private var myBadgeRepository: MyBadgeRepository
    private let userDefaults: UserDefaults
    // 서버가 "방금 해금됨" 여부를 따로 안 줘서, 마지막으로 축하 모달을 보여준 뱃지 코드를
    // 기기에 직접 기억해두고 비교한다.
    private static let seenUnlockedBadgeCodesKey = "myBadge.seenUnlockedCodes"

    var badges: [MyBadge] = []

    var unlockedCount: Int {
        badges.filter { $0.isUnlocked }.count
    }

    // 해금됐지만 아직 축하 모달을 확인 안 한 뱃지들.
    var newlyUnlockedBadges: [MyBadge] {
        let seen = Set(userDefaults.stringArray(forKey: Self.seenUnlockedBadgeCodesKey) ?? [])
        return badges.filter { $0.isUnlocked && !seen.contains($0.code) }
    }

    init(myBadgeRepository: MyBadgeRepository = MockMyBadgeRepository(), userDefaults: UserDefaults = .standard) {
        self.myBadgeRepository = myBadgeRepository
        self.userDefaults = userDefaults
    }

    @MainActor
    func loadMyBadges() async {
        badges = (try? await myBadgeRepository.fetchMyBadges()) ?? []
        // 이 기능이 생기기 전부터 이미 해금돼 있던 뱃지까지 전부 "새로 해금됨"으로 뜨면 안
        // 되니, 기록이 아예 없는 최초 1회만 지금 해금된 것들을 전부 "이미 봤다"로 간주한다.
        if userDefaults.object(forKey: Self.seenUnlockedBadgeCodesKey) == nil {
            userDefaults.set(badges.filter(\.isUnlocked).map(\.code), forKey: Self.seenUnlockedBadgeCodesKey)
        }
    }

    // 축하 모달을 확인(닫음) 처리 — 다음부터 이 뱃지는 다시 안 뜬다.
    func confirmSeen(_ badge: MyBadge) {
        var seen = Set(userDefaults.stringArray(forKey: Self.seenUnlockedBadgeCodesKey) ?? [])
        seen.insert(badge.code)
        userDefaults.set(Array(seen), forKey: Self.seenUnlockedBadgeCodesKey)
    }
}
