//
//  MyPageProfileImageView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//

import SwiftUI

struct MyPageProfileImageView: View {
    @ObservedObject var myPageViewModel: MyPageViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Circle()
                .frame(width: 84, height: 84)
                .foregroundStyle(Color.white)
            
            HStack(spacing: 4) {
                Button(action: {}) {
                    if let nickname = myPageViewModel.userInfo?.nickname {
                        Text(nickname)
                            .pickpleTypography(.title02)
                            .foregroundStyle(Color.white)
                    }
                    Image("PickpleEdit")
                }
            }
        }
        
        .frame(maxWidth: .infinity)
    }
        
}

#Preview {
    MyPageProfileImageView(myPageViewModel: MyPageViewModel())
}
