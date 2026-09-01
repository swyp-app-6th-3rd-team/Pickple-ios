//
//  MyPageViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//
import Combine

class MyPageViewModel: ObservableObject {
    private var userInfoRepository: UserInfoRepository
    
    @Published var userInfo: UserInfo?
    
    init(userInfoRepository: UserInfoRepository = MockUserInfoRepository()) {
        self.userInfoRepository = userInfoRepository
    }
    
    func loadUserInfo() async {
        userInfo = await userInfoRepository.fetchUserInfo()
    }
}
