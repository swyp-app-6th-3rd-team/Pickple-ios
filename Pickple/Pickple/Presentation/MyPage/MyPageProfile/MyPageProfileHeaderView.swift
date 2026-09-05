//
//  MyPageProfileHeaderView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//

import SwiftUI

struct MyPageProfileHeaderView: View {
    @ObservedObject var myPageViewModel: MyPageViewModel

    var body: some View {
        Button(action: {}) {
            VStack(spacing: 12) {
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
                }
            }
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .background(Color.navy60)
            
        }
    
    }
        


#Preview {
    MyPageProfileHeaderView(myPageViewModel: MyPageViewModel())
}
