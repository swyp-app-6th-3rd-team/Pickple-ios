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

    var body: some View {
        Button(action: { myPageRouter.push(.profile) }) {
            VStack(spacing: 12) {
                // 게스트는 프로필 이미지를 조회할 계정이 없어서 기본 이미지로 고정한다.
                if myPageViewModel.isLoggedIn {
                    AsyncImage(url: myPageViewModel.userInfo?.profileImageUrl) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Image("PickpleCharacter").resizable().scaledToFill()
                    }
                    .frame(width: 84, height: 84)
                    .clipShape(Circle())
                } else {
                    Image("PickpleCharacter").resizable().scaledToFill()
                        .frame(width: 84, height: 84)
                        .clipShape(Circle())
                }

                HStack(spacing: 4) {
                    if myPageViewModel.isLoggedIn {
                        if let nickname = myPageViewModel.userInfo?.nickname {
                            Text(nickname)
                                .pickpleTypography(.title02)
                                .foregroundStyle(Color.white)
                        }
                    } else {
                        Text(MyPageStrings.guestNickname)
                            .pickpleTypography(.title02)
                            .foregroundStyle(Color.white)
                    }
                    Image("PickpleEdit")
                }
            }
        }
        .disabled(!myPageViewModel.isLoggedIn)
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .background(Color.navy60)
    }
}

#Preview {
    MyPageProfileHeaderView(myPageViewModel: MyPageViewModel())
}
