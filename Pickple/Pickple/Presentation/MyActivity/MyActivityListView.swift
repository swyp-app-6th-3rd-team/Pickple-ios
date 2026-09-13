//
//  MyActivityListView.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  나의 활동 세 탭이 각자 다른 아이템 타입(PostSummary/MyCommentActivity)을 쓰게 되면서,
//  빈 상태 처리를 매번 복붙하지 않도록 아이템/행 뷰를 제네릭으로 받는다.
// 1차 점검 완료 - 9월 13일

import SwiftUI

struct MyActivityListView<Item: Identifiable, RowContent: View>: View {
    let items: [Item]
    // 마지막 아이템이 화면에 나타났을 때 호출 — 다음 페이지를 이어 받는 트리거용(기본은 no-op).
    var onReachEnd: (Item) -> Void = { _ in }
    // 카드를 탭했을 때 호출 — 참조 게시글 상세로 이동시키는 트리거용(기본은 no-op).
    var onTapItem: (Item) -> Void = { _ in }
    @ViewBuilder let row: (Item) -> RowContent

    var body: some View {
        if items.isEmpty {
            VStack(spacing: 20) {
                Spacer()
                Text(MyActivityStrings.emptyMessage)
                Spacer()
            }
        } else {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(items) { item in
                        Button(action: { onTapItem(item) }) {
                            row(item)
                                .multilineTextAlignment(.leading)

                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .task {
                            if item.id == items.last?.id {
                                onReachEnd(item)
                            }
                        }
                        Divider()
                    }
                }
            }
        }
    }
}

#Preview("투표 탭") {
    MyActivityListView(
        items: [
            PostSummary(
                id: 1, type: .forAgainst, category: "전자제품", title: "노트북 살까 말까",
                description: "재택근무용으로 하나 더 살까 하는데 이미 있는 거로 버텨야 할지 고민이네요.",
                thumbnailUrl: nil, authorNickname: "라떼한잔", authorLevel: 3, authorProfileImageUrl: nil,
                voteCount: 24, commentCount: 9, createdAt: Date().addingTimeInterval(-60 * 30),
                voteResult: PostVoteResult(firstLabel: "사자", secondLabel: "말자", firstPercentage: 70, secondPercentage: 30, votedSide: .first)
            ),
            PostSummary(
                id: 2, type: .ab, category: "화장품/뷰티", title: "선크림 A vs B",
                description: "여름 다가오는데 백탁 없고 산뜻한 걸로 고르려니 둘 중 뭐가 나을지 모르겠어요.",
                thumbnailUrl: nil, authorNickname: "여름햇살", authorLevel: 5, authorProfileImageUrl: nil,
                voteCount: 15, commentCount: 3, createdAt: Date().addingTimeInterval(-60 * 60 * 6),
                voteResult: PostVoteResult(firstLabel: "A", secondLabel: "B", firstPercentage: 40, secondPercentage: 60, votedSide: .second)
            ),
        ]
    ) { post in
        MyActivityVotedPostCardView(post: post)
    }
}

#Preview("작성글 탭") {
    MyActivityListView(
        items: [
            PostSummary(
                id: 3, type: .text, category: "생활용품", title: "이 청소기 써본 사람?",
                description: "무선 청소기 사려는데 흡입력이랑 배터리 오래가는 제품 추천 좀요.",
                thumbnailUrl: nil, authorProfileImageUrl: nil,
                voteCount: 0, commentCount: 1, createdAt: Date().addingTimeInterval(-60 * 60 * 24)
            ),
        ]
    ) { post in
        MyActivityWrittenPostCardView(post: post)
    }
}

#Preview("댓글 탭") {
    MyActivityListView(
        items: [
            MyCommentActivity(
                id: 1,
                content: "그것도 괜찮아보이지만 차라리 같은 흰 색으로 두 켤레 살거면 다른 모델로 사는편이 좋지 않을까?",
                pickCount: 3,
                createdAt: Date().addingTimeInterval(-60 * 5),
                referencedPost: MyCommentActivityPostReference(id: 201, type: .forAgainst, title: "나이키 에어포스 흰색으로 살까?", thumbnailUrl: nil, voteCount: 12, commentCount: 4)
            ),
        ]
    ) { activity in
        MyActivityCommentActivityRow(activity: activity)
    }
}

#Preview("빈 상태") {
    MyActivityListView(items: [PostSummary]()) { post in
        MyActivityWrittenPostCardView(post: post)
    }
}
