//
//  CommunityPostListSection.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료 - 9월 12일

import SwiftUI

struct CommunityPostListSection: View {
    @Bindable var communityViewModel: CommunityViewModel
    var onTapPost: (PostSummary) -> Void = { _ in }

    var body: some View {
        if communityViewModel.displayedPosts.isEmpty {
            CommunityEmptyView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(communityViewModel.displayedPosts) { post in
                        CommunityPostCardView(post: post)
                            // 리스트(LazyVStack) 레벨에서 주던 좌우 여백을 카드 자신에게 직접 준다.
                            // 시뮬레이터 실기기에서 LazyVStack의 padding이 .frame(maxWidth: .infinity)로
                            // 늘어나는 썸네일 이미지까지는 제대로 전파되지 않아, 이미지만 화면 끝까지
                            // 꽉 차 보이던 문제(프리뷰에서는 재현 안 됨) — 카드 자체에 패딩을 주면
                            // 이미지도 카드 폭 기준으로 계산되어 이 전파 문제를 피한다.
                            .padding(.horizontal, 20)
                            .onTapGesture { onTapPost(post) }
                            .task { await communityViewModel.loadMoreIfNeeded(currentPost: post) }

                    }
                }
            }
            .scrollPosition($communityViewModel.scrollPosition)
            .onScrollGeometryChange(for: CGFloat.self) { geometry in
                geometry.contentOffset.y
            } action: { _, newValue in
                withAnimation(.easeInOut(duration: 0.2)) {
                    communityViewModel.isScrolledDown = newValue > CommunityViewModel.scrollDownThreshold
                }
            }
        }
    }
}

#Preview {
    CommunityPostListSection(communityViewModel: CommunityViewModel())
}
