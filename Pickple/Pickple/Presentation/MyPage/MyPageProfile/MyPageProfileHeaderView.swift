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
                    AsyncImage(url: myPageViewModel.userInfo?.profileImageUrl) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Image("PickpleCharacter").resizable().scaledToFill()
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
                        
                        Button(action: {}) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(maxWidth: .infinity, minHeight: 56)
                                    .foregroundStyle(Color.yellow60)
                                Text("로그인")
                                    .pickpleTypography(.title02)
                                    .foregroundStyle(Color.navy60)
                            }
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
