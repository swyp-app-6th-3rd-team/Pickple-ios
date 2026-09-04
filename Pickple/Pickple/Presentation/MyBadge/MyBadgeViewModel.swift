//
//  MyBadgeViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import Combine

class MyBadgeViewModel: ObservableObject {
    private var myBadgeRepository: MyBadgeRepository

    @Published var badges: [MyBadge] = []

    var unlockedCount: Int {
        badges.filter { $0.isUnlocked }.count
    }

    init(myBadgeRepository: MyBadgeRepository = MockMyBadgeRepository()) {
        self.myBadgeRepository = myBadgeRepository
    }

    func loadMyBadges() async {
        badges = (try? await myBadgeRepository.fetchMyBadges()) ?? []
    }
}
