//
//  PostDetailHeaderSection.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료 - 9월 12일

import SwiftUI

// 유형 배지/제목/작성자/설명까지, 게시글 상세 상단 정보 블록.
struct PostDetailHeaderSection: View {
    let post: PostDetail
    let onMoreTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 6) {
                    PostDetailHeaderRow(type: post.type, onMoreTapped: onMoreTapped)

                    Text(post.title)
                        .pickpleTypography(.heading02)
                        .foregroundStyle(Color.black)
                }

                PostDetailAuthorRow(nickname: post.authorNickname, level: post.authorGradeLevel, profileImageUrl: post.authorProfileImageUrl, createdAt: post.createdAt)
            }

            if !post.description.isEmpty {
                Text(post.description)
                    .pickpleTypography(.body01)
                    .foregroundStyle(Color.neutral50)
            }
        }
    }
}

#Preview {
    PostDetailHeaderSection(
        post: PostDetail(
            id: 1,
            type: .forAgainst,
            category: "패션/잡화",
            title: "나이키 에어포스 흰색",
            description: "데일리로 신을건데 나이키 에어포스 흰색 어때?",
            createdAt: Date(),
            commentCount: 3,
            authorId: 1,
            authorNickname: "닉네임",
            authorProfileImageUrl: nil,
            authorGradeLevel: 5,
            authorGradeName: "LV.5",
            authorRanking: nil,
            isMine: true,
            vote: nil
        ),
        onMoreTapped: {}
    )
    .padding()
}
