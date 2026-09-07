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
    
    init(
        userInfoRepository: UserInfoRepository = MockUserInfoRepository(),
        userPostRepository: UserPostRepository = MockUserPostRepository()
    ) {
        self.userInfoRepository = userInfoRepository
        self.userPostRepository = userPostRepository
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
