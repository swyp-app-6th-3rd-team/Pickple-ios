//
//  CommunityPostListSection.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료 - 9월 12일

import SwiftUI
import UIKit

struct CommunityPostListSection: View {
    @Bindable var communityViewModel: CommunityViewModel
    var onTapPost: (PostSummary) -> Void = { _ in }
    // 하단 탭바 숨김/노출 전용 — communityViewModel.isScrolledDown(맨 위에서 얼마나
    // 내려갔는지, 최상단 이동 버튼 노출 기준)과는 별개로 스크롤 "방향"만 알려준다.
    // 같은 값을 같이 쓰면, 리스트 중간에서 위로 살짝만 스크롤해도 최상단 이동 버튼이
    // 바로 사라져버려서(그 버튼은 위치 기준이 맞다) 두 신호를 분리했다.
    var onScrollDirectionChange: (Bool) -> Void = { _ in }

    var body: some View {
        if communityViewModel.displayedPosts.isEmpty {
            CommunityEmptyView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(communityViewModel.displayedPosts) { post in
                        Button(action: { onTapPost(post) }) {
                            CommunityPostCardView(post: post)
                                // 리스트(LazyVStack) 레벨에서 주던 좌우 여백을 카드 자신에게 직접 준다.
                                // 시뮬레이터 실기기에서 LazyVStack의 padding이 .frame(maxWidth: .infinity)로
                                // 늘어나는 썸네일 이미지까지는 제대로 전파되지 않아, 이미지만 화면 끝까지
                                // 꽉 차 보이던 문제(프리뷰에서는 재현 안 됨) — 카드 자체에 패딩을 주면
                                // 이미지도 카드 폭 기준으로 계산되어 이 전파 문제를 피한다.
                                .padding(.horizontal, 20)
                                // Button은 기본적으로 라벨의 실제로 그려진 영역만 히트테스트한다 —
                                // 카드 내부 여백(줄 간격 등)이 탭에 반응 안 하고 옆/아래 카드로 새던
                                // 문제가 있어서, 카드 전체 사각형을 하나의 히트 영역으로 명시한다.
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .task {
                            await communityViewModel.loadMoreIfNeeded(currentPost: post)
                            prefetchUpcomingImages(after: post)
                        }
                    }
                }
                .onScrollDirectionChange { scrolledDown in
                    // MainView/MyPageView가 탭바 숨김/노출을 감싸는 것과 동일한 애니메이션으로
                    // 맞춘다 — 안 그러면 커뮤니티 탭만 전환 커브/시간이 달라 보인다.
                    withAnimation(.easeInOut(duration: 0.2)) {
                        onScrollDirectionChange(scrolledDown)
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
            .refreshable {
                await communityViewModel.loadPosts()
            }
        }
    }

    // 현재 카드 기준 다음 3장의 카드가 쓸 이미지를 미리 받아 캐시를 데워둔다 —
    // CommunityPostCardView와 같은 target size를 써야 캐시가 재사용된다.
    private func prefetchUpcomingImages(after post: PostSummary) {
        guard let index = communityViewModel.displayedPosts.firstIndex(where: { $0.id == post.id }) else { return }
        let urls = communityViewModel.displayedPosts[index...].dropFirst().prefix(3).flatMap { $0.displayedImageURLs }
        PickpleImagePrefetcher.prefetch(urls: urls, targetSize: CGSize(width: UIScreen.main.bounds.width, height: 150))
    }
}

#Preview {
    CommunityPostListSection(communityViewModel: CommunityViewModel())
}
