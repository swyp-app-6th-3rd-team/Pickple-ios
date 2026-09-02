//
//  SwiftUIView.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//

import SwiftUI

struct MyPagePostView: View {
    @ObservedObject var myPageViewModel: MyPageViewModel
    
    var body: some View {
        VStack(spacing: 12){
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
            .padding(.horizontal, 20)
            
            //MARK: - Post
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(myPageViewModel.posts) { post in
                        Button(action: {}) {
                            VStack(spacing: 8) {
                                ZStack (alignment: .topLeading){
                                    Image(post.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 160, height: 160) //Fixed
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    
                                    HStack {
                                        switch post.type {
                                        case .text: Image("PickpleText").resizable().frame(width: 16, height: 16)
                                        case .forAgainst: Image("PickpleAgainst").resizable().frame(width: 16, height: 16)
                                        case .compare: Image("PickpleAB").resizable().frame(width: 16, height: 16)
                                        }
                                            
                                        
                                        
                                        Text(post.type.displayName)
                                            .pickpleTypography(.label)
                                            .foregroundStyle(Color.white)
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .foregroundStyle(Color.black)
                                    )
                                    .padding(10)
                                    
                                }
                                
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(post.category)
                                            .pickpleTypography(.caption)
                                            .foregroundStyle(Color.neutral50)
                                        
                                        Text(post.title)
                                            .lineLimit(1)
                                            .pickpleTypography(.body01)
                                            .foregroundStyle(Color.black)
                                    }
                                    Spacer()
                                }
                                
                                
                                HStack {
                                    HStack(spacing: 12) {
                                        HStack(spacing: 4) {
                                            Image("PickpleVote")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                            Text("\(post.voteCount)")
                                        }
                                        
                                        HStack(spacing: 4) {
                                            Image("PickpleComment")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                            
                                            Text("\(post.commentCount)")
                                        }
                                    }
                                    .pickpleTypography(.label)
                                    .foregroundStyle(Color.neutral30)
                                    
                                    Spacer()
                                    
                                    Text(post.createdAt.relativeTimeDescription)
                                        .pickpleTypography(.caption)
                                        .foregroundStyle(Color.neutral40)
                                }
                                
                            }
                            .frame(width: 160)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            
        }
        .padding(.vertical, 16)

        .background(Color.white)
        .task {
            await myPageViewModel.loadMyPosts()
        }
    }
}

#Preview {
    MyPagePostView(myPageViewModel: MyPageViewModel())
}
