//
//  PostDetailCommentRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 원픽 아이콘은 임시값(전용 에셋 없음)

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
                HStack(spacing: 12) {
                if let authorProfileImageUrl = comment.authorProfileImageUrl {
                    AsyncImage(url: authorProfileImageUrl) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundStyle(Color.neutral20)
                    }
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(Color.neutral20)
                }
                    HStack(spacing: 2) {
                    Text(comment.authorNickname)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.neutral100)
                    
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
                        Image("PickpleOnePick")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(PostDetailStrings.pickCount(comment.pickCount))
                    }
                    .pickpleTypography(.label)
                    .foregroundStyle(isPicked ? Color.red60 : Color.neutral30)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(isPicked ? Color.red10 : Color.neutral5)
                    .clipShape(Capsule())
                }
                .disabled(!canPick)
                
                Spacer()
                //XMARK: - Time
                Text(comment.createdAt.relativeTimeDescription)
                    .pickpleTypography(.caption)
                    .foregroundStyle(Color.neutral40)
            }
            
            Divider()
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
