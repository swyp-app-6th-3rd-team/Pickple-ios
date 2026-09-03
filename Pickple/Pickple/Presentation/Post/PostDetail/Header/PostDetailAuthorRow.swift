//
//  PostDetailAuthorRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
import SwiftUI

struct PostDetailAuthorRow: View {
    let nickname: String
    let level: Int
    let profileImageName: String?
    let createdAt: Date

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()

    var body: some View {
            HStack(spacing: 12) {
                if let profileImageName {
                    Image(profileImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(Color.neutral20)
                }
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 2) {
                        Text(nickname)
                            .pickpleTypography(.label)
                            .foregroundStyle(Color.neutral70)
                        
                        
                        Image("PickpleLevelBadge\(level)")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    
                    HStack(spacing: 4) {
                        Text("\(Self.dateFormatter.string(from: createdAt))")
                            .foregroundStyle(Color.neutral30)
                        Text("·")
                            .foregroundStyle(Color.neutral10)
                        
                        Text("\(createdAt.relativeTimeDescription)")
                            .foregroundStyle(Color.neutral30)
                    }
                    .pickpleTypography(.caption)
                    
                }
            }
        
    }
}

#Preview {
    PostDetailAuthorRow(nickname: "닉네임", level: 5, profileImageName: "PickpleProfileSample", createdAt: Date())
        .padding()
}
