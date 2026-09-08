//
//  MyPageViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//
import Foundation

@Observable
class MyPageViewModel {
    private var userInfoRepository: UserInfoRepository
    private var userPostRepository: UserPostRepository

    var userInfo: UserInfo?
    var posts: [PostSummary] = []
    private(set) var isLoggedIn: Bool

    init(
        userInfoRepository: UserInfoRepository = MockUserInfoRepository(),
        userPostRepository: UserPostRepository = MockUserPostRepository(),
        isLoggedIn: Bool = true
    ) {
        self.userInfoRepository = userInfoRepository
        self.userPostRepository = userPostRepository
        self.isLoggedIn = isLoggedIn
    }
    
    @MainActor
    func loadUserInfo() async {
        userInfo = try? await userInfoRepository.fetchUserInfo()
    }

    @MainActor
    func loadMyPosts() async {
        posts = (try? await userPostRepository.fetchMyPosts()) ?? []
    }
}
