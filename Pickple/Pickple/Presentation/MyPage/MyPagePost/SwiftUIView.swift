//
//  SwiftUIView.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//

import SwiftUI

struct SwiftUIView: View {
    @ObservedObject var myPageViewModel: MyPageViewModel
    
    var body: some View {
        VStack {
            
            //XMARK: - Title
            HStack {
                Text("내가 올린 투표")
                    .pickpleTypography(.title01)
                    .foregroundStyle(Color.black)
                
                Spacer()
                
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Text("전체 보기")
                        
                        Image("PickpleArrowRight")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                        
                }
                .pickpleTypography(.body02)
                .foregroundStyle(Color.neutral40)
            }
            .padding(20)
            
            //MARK: - Post
            ScrollView(.horizontal) {
                ForEach(myPageViewModel.userInfo?, id: \.self) {
                    
                }
                
            }
            
        }
    }
}

#Preview {
    SwiftUIView(myPageViewModel: MyPageViewModel())
}
