//
//  PostDetailHeaderSection.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//

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
                        .pickpleTypography(.title01)
                        .foregroundStyle(Color.black)
                }

                PostDetailAuthorRow(nickname: post.authorNickname, level: post.authorLevel, profileImageName: post.authorProfileImageName, createdAt: post.createdAt)
            }

            Text(post.description)
                .pickpleTypography(.body01)
                .foregroundStyle(Color.neutral50)
        }
    }
}

#Preview {
    PostDetailHeaderSection(
        post: PostDetail(
            id: UUID(),
            type: .forAgainst,
            category: "패션/잡화",
            title: "나이키 에어포스 흰색",
            description: "데일리로 신을건데 나이키 에어포스 흰색 어때?",
            images: [],
            authorNickname: "닉네임",
            authorLevel: 5,
            authorProfileImageName: "PickpleProfileSample",
            isMine: true,
            createdAt: Date(),
            participantCount: 3,
            firstProduct: nil,
            secondProduct: nil
        ),
        onMoreTapped: {}
    )
    .padding()
}
