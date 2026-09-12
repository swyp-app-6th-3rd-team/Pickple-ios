//
//  PostDetailAuthorRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료
// 게시글 작성 날짜 폰트 미지정
// 게시글 작성 시간 폰트 미지정

import SwiftUI

struct PostDetailAuthorRow: View {
    let nickname: String
    let level: Int
    let profileImageUrl: URL?
    let createdAt: Date

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()

    var body: some View {
            HStack(spacing: 12) {
                AsyncImage(url: profileImageUrl) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Image("PickpleCharacter").resizable().scaledToFill()
                }
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.navy10)
                        .foregroundStyle(Color.white)
                )
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 2) {
                        Text(nickname)
                            .pickpleTypography(.label)
                            .foregroundStyle(Color.neutral70)
                        
                        
                        Image("PickpleLevelBadge\(level)")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    
                    HStack(spacing: 4) {
                        Text("\(Self.dateFormatter.string(from: createdAt))")
                            .foregroundStyle(Color.neutral30)
                        //폰트 미지정
                        Text("·")
                            .foregroundStyle(Color.neutral10)
                        
                        Text("\(createdAt.relativeTimeDescription)")
                            .foregroundStyle(Color.neutral30)
                        // 폰트 미지정
                    }
                    .pickpleTypography(.caption)
                    
                }
            }
        
    }
}

#Preview {
    PostDetailAuthorRow(nickname: "닉네임", level: 5, profileImageUrl: nil, createdAt: Date())
        .padding()
}
