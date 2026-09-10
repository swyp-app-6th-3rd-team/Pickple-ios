//
//  MyPageProfileHeaderView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//

import SwiftUI

struct MyPageProfileHeaderView: View {
    @Environment(MyPageRouter.self) private var myPageRouter
    let myPageViewModel: MyPageViewModel
    var onLoginTapped: () -> Void = {}

    var body: some View {
        Button(action: {
            if myPageViewModel.isLoggedIn {
                myPageRouter.push(.profile)
            } else {
                onLoginTapped()
            }
        }) {
            VStack(spacing: 12) {
                if myPageViewModel.isLoggedIn {
                    // 서버가 실제 사진을 안 줬을 때(기본 프로필)는 캐릭터 이미지 뒤에 흰 배경
                    // 원을 깔아준다 — 캐릭터 이미지 자체의 크기(scaledToFill)는 실제 사진과 동일하게
                    // 유지하고, 투명한 부분에 navy60 배경이 아니라 흰색이 보이게 하는 목적.
                    AsyncImage(url: myPageViewModel.userInfo?.profileImageUrl) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        ZStack {
                            Circle().fill(Color.white)
                            Image("PickpleCharacter").resizable().scaledToFill()
                        }
                    }
                    .frame(width: 84, height: 84)
                    .clipShape(Circle())

                    HStack(spacing: 4) {
                        if let nickname = myPageViewModel.userInfo?.nickname {
                            Text(nickname)
                                .pickpleTypography(.title02)
                                .foregroundStyle(Color.white)
                        }
                        Image("PickpleEdit")
                    }
                } else {
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("지금 로그인 후 더 많은")
                                Text("투표를 해 주세요!")
                                
                            }
                            .pickpleTypography(.title01)
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, 20)
                            
                            Spacer()
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(maxWidth: .infinity, minHeight: 56)
                                .foregroundStyle(Color.yellow60)
                            Text("로그인")
                                .pickpleTypography(.title02)
                                .foregroundStyle(Color.navy60)
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .background(Color.navy60)
    }
}

#Preview {
    MyPageProfileHeaderView(myPageViewModel: MyPageViewModel())
        .environment(MyPageRouter())
}
