//
//  MyPageViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//
import Combine

class MyPageViewModel: ObservableObject {
    private var userInfoRepository: UserInfoRepository
    private var userPostRepository: UserPostRepository
    
    @Published var userInfo: UserInfo?
    @Published var posts: [PostSummary] = []
    
    init(
        userInfoRepository: UserInfoRepository = MockUserInfoRepository(),
        userPostRepository: UserPostRepository = MockUserPostRepository()
    ) {
        self.userInfoRepository = userInfoRepository
        self.userPostRepository = userPostRepository
    }
    
    func loadUserInfo() async {
        userInfo = await userInfoRepository.fetchUserInfo()
    }
    
    func loadMyPosts() async {
        posts = await userPostRepository.fetchMyPosts()
    }
}
