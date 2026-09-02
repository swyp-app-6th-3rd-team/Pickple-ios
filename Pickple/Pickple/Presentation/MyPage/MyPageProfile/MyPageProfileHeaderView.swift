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
                Circle()
                    .frame(width: 84, height: 84)
                    .foregroundStyle(Color.white)
                
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
