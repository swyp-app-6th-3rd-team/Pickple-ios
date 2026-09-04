//
//  MyPageStatsView.swift
//  Pickple
//
//  Created by 박윤수 on 9/1/26.
//

import SwiftUI

struct MyPageStatsView: View {
    @ObservedObject var myPageViewModel: MyPageViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            VStack {
                Text(MyPageStrings.voteCount)
                    .pickpleTypography(.label)
                    .foregroundStyle(Color.navy40)
                
                if let vote = myPageViewModel.userInfo?.voteCount {
                    Text("\(vote)")
                        .pickpleTypography(.title02)
                        .foregroundStyle(Color.neutral100)
                }
                
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .frame(height: 30)
            
            VStack {
                Text(MyPageStrings.commentCount)
                    .pickpleTypography(.label)
                    .foregroundStyle(Color.navy40)
                
                if let comment = myPageViewModel.userInfo?.commentCount {
                    Text("\(comment)")
                        .pickpleTypography(.title02)
                        .foregroundStyle(Color.neutral100)
                }
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .frame(height: 30)
            
            VStack {
                Text(MyPageStrings.postCount)
                    .pickpleTypography(.label)
                    .foregroundStyle(Color.navy40)
                
                if let post = myPageViewModel.userInfo?.postCount {
                    Text("\(post)")
                        .pickpleTypography(.title02)
                        .foregroundStyle(Color.neutral100)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(width: 353) //Fiexd

    }
}

#Preview {
    MyPageStatsView(myPageViewModel: MyPageViewModel())
}
