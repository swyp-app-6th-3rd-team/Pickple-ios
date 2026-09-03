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
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                HStack(spacing: 12) {
                if let authorProfileImageName = comment.authorProfileImageName {
                    Image(authorProfileImageName)
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
                
                HStack(spacing: 2) {
                    Text(comment.authorNickname)
                        .pickpleTypography(.body01)
                        .foregroundStyle(Color.neutral100)
                    
                    Image("PickpleLevelBadge\(comment.authorLevel)")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }

                Spacer()

                Button(action: onMoreTapped) {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.neutral40)
                }
            }

            Text(comment.content)
                .pickpleTypography(.body01)
                .foregroundStyle(Color.neutral70)

            HStack(spacing: 8) {
                Button(action: onPickTapped) {
                    HStack(spacing: 4) {
                        Image(systemName: "hand.thumbsup.fill")
                        Text("원픽 \(comment.pickCount)")
                    }
                    .pickpleTypography(.caption)
                    .foregroundStyle(isPicked ? Color.red60 : Color.neutral40)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(isPicked ? Color.red10 : Color.neutral5)
                    .clipShape(Capsule())
                }
                .disabled(!canPick)

                Text(comment.createdAt.relativeTimeDescription)
                    .pickpleTypography(.caption)
                    .foregroundStyle(Color.neutral40)
            }
        }
    }
}

#Preview {
    PostDetailCommentRow(
        comment: Comment(id: UUID(), authorNickname: "픽플고인물", authorLevel: 5, authorProfileImageName: "PickpleProfileSample", content: "이거 너무 좋아요", createdAt: Date(), pickCount: 3),
        isPicked: false,
        canPick: true,
        onMoreTapped: {},
        onPickTapped: {}
    )
    .padding()
}
