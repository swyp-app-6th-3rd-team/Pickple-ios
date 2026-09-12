//
//  PostDetailCommentRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  1차 점검 완료 - 9월 13일
// 댓글 작성 시간 폰트 미지정

import SwiftUI

struct PostDetailCommentRow: View {
    let comment: Comment
    let isPicked: Bool
    let canPick: Bool
    let onMoreTapped: () -> Void
    let onPickTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
                //MARK: - Profile
                HStack(spacing: 8) {
                AsyncImage(url: comment.authorProfileImageUrl) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Image("PickpleCharacter").resizable().scaledToFill()
                }
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.navy10)
                        .frame(width: 32, height: 32)
                )
                    HStack(spacing: 2) {
                    Text(comment.authorNickname)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.neutral80)
                        
                    
                    Image("PickpleLevelBadge\(comment.authorLevel)")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                    
                    Spacer()
                    //MARK: - Menu
                    Button(action: onMoreTapped) {
                        Image("PickpleMenu")
                            .foregroundStyle(Color.neutral30)
                    }
            }
            
            //MARK: - Content
            Text(comment.content)
                .pickpleTypography(.body01)
                .foregroundStyle(Color.neutral80)

            HStack {
                Button(action: onPickTapped) {
                    
                    //MARK: - OnePick
                    HStack(spacing: 4) {
                        Image(isPicked ? "Gamification" : "PickpleOnePick")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(PostDetailStrings.pickCount(comment.pickCount))
                    }
                    .pickpleTypography(.label)
                    .foregroundStyle(isPicked ? Color.black : Color.neutral30)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(isPicked ? Color.yellow60 : Color.neutral5)
                    .clipShape(Capsule())
                }
                .disabled(!canPick)
                
                Spacer()
                //XMARK: - Time
                Text(comment.createdAt.relativeTimeDescription)
                    .pickpleTypography(.caption)
                    .foregroundStyle(Color.neutral30)
            }
        }
    }
}

#Preview {
    PostDetailCommentRow(
        comment: Comment(id: 1, authorNickname: "픽플고인물", authorLevel: 5, authorProfileImageUrl: nil, content: "이거 너무 좋아요", createdAt: Date(), pickCount: 3, mine: false),
        isPicked: false,
        canPick: true,
        onMoreTapped: {},
        onPickTapped: {}
    )
    .padding()
}
