//
//  MyActivityCommentActivityRow.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  나의 활동 '댓글' 탭 전용 행. 다른 두 탭과 달리 게시글 카드가 아니라 내가 쓴 댓글 내용이
//  주인공이고, 그 댓글이 달린 원본 게시글은 참조(제목+타입 아이콘)로만 붙는다.

import SwiftUI

struct MyActivityCommentActivityRow: View {
    let activity: MyCommentActivity

    private var referencedPostTypeIcon: String {
        switch activity.referencedPost.type {
        case .text: return "PickpleText"
        case .forAgainst: return "PickpleAgainst"
        case .ab: return "PickpleAB"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                Text(activity.content)
                    .lineLimit(2)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.black)

                Spacer()

                if let thumbnailUrl = activity.referencedPost.thumbnailUrl {
                    AsyncImage(url: thumbnailUrl) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Image("McokMyPostPicture").resizable().scaledToFill()
                    }
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .clipped()
                }
            }

            HStack(spacing: 4) {
                Image(referencedPostTypeIcon)
                    .resizable()
                    .frame(width: 14, height: 14)

                Text(activity.referencedPost.title)
                    .lineLimit(1)
            }
            .pickpleTypography(.caption)
            .foregroundStyle(Color.neutral50)

            HStack {
                HStack(spacing: 4) {
                    Image("PickpleOnePick")
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text(PostDetailStrings.pickCount(activity.pickCount))
                }
                .pickpleTypography(.label)
                .foregroundStyle(Color.neutral30)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.neutral5)
                .clipShape(Capsule())

                Spacer()

                Text(activity.createdAt.relativeTimeDescription)
                    .pickpleTypography(.caption)
                    .foregroundStyle(Color.neutral40)
            }
        }
    }
}

#Preview("원픽 있음") {
    MyActivityCommentActivityRow(
        activity: MyCommentActivity(
            id: 1,
            content: "그것도 괜찮아보이지만 차라리 같은 흰 색으로 두 켤레 살거면 다른 모델로 사는편이 좋지 않을까?",
            pickCount: 3,
            createdAt: Date().addingTimeInterval(-60 * 5),
            referencedPost: MyCommentActivityPostReference(id: 201, type: .forAgainst, title: "나이키 에어포스 흰색으로 살까?", thumbnailUrl: nil)
        )
    )
    .padding()
}

#Preview("원픽 0") {
    MyActivityCommentActivityRow(
        activity: MyCommentActivity(
            id: 2,
            content: "○○ 그거 맞음",
            pickCount: 0,
            createdAt: Date().addingTimeInterval(-60 * 5),
            referencedPost: MyCommentActivityPostReference(id: 202, type: .ab, title: "OOTD 몇 번 룩이 가장 좋아요?", thumbnailUrl: nil)
        )
    )
    .padding()
}

#Preview("참조글 썸네일 없음(text 타입)") {
    MyActivityCommentActivityRow(
        activity: MyCommentActivity(
            id: 3,
            content: "저도 궁금했던 내용이네요, 좋은 정보 감사합니다.",
            pickCount: 1,
            createdAt: Date().addingTimeInterval(-60 * 60),
            referencedPost: MyCommentActivityPostReference(id: 203, type: .text, title: "가습기 추천 좀요", thumbnailUrl: nil)
        )
    )
    .padding()
}
