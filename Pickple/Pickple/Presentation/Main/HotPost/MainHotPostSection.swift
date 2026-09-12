//
//  MainHotPostSection.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료 9월 12일
// 빈 화면 디자인 필요

import SwiftUI

struct MainHotPostSection: View {
    let posts: [PostSummary]
    let onTapPost: (PostSummary) -> Void
    let onTapMore: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(MainStrings.hotPostSectionTitle)
                    .pickpleTypography(.title01)
                    .foregroundStyle(Color.black)
                
                Spacer()
                
                Button(action: onTapMore) {
                    HStack(spacing: 4) {
                        Text(MainStrings.more)
                        Image("PickpleArrowRight")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    .pickpleTypography(.body02)
                    .foregroundStyle(Color.neutral40)
                }
            }
            
            if posts.isEmpty {
                //임시 디자인
                Text(MainStrings.hotPostEmptyMessage)
                    .pickpleTypography(.body02)
                    .foregroundStyle(Color.neutral40)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(posts) { post in
                            PostThumbnailCardView(post: post)
                                .onTapGesture { onTapPost(post) }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MainHotPostSection(posts: [], onTapPost: { _ in }, onTapMore: {})
}
