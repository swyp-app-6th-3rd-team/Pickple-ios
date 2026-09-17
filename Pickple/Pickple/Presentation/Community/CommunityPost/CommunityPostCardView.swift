//
//  CommunityPostCardView.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
// 1차 점검 완료 - 9월 12일
// 미지정 폰트 확인 필요
// 분리 바 확인 필요(리소스 및 색상)

import SwiftUI
import UIKit

struct CommunityPostCardView: View {
    let post: PostSummary
    
    var body: some View {
        VStack(spacing: 8) {
            // 일반 게시글은 서버가 애초에 thumbnailUrl을 안 준다 — 그런데도
            // AsyncImage의 placeholder가 목업 사진을 채워서 없는 이미지가 있는 것처럼 보였다.
            // 유형 배지는 이미지 유무와 무관하게 항상 보여야 하므로 이미지만 조건부로 뺀다.
            if post.type == .text {
                HStack {
                    PostTypeBadge(type: post.type)
                    Spacer()
                }
            } else {
                ZStack(alignment: .topLeading) {
                    if post.type == .ab {
                        abThumbnails
                    } else {
                        thumbnailImage(url: post.thumbnailUrl)
                            .frame(height: 150)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .clipped()
                    }

                    PostTypeBadge(type: post.type)
                        .padding(10)
                }
            }
            
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(post.title)
                        .pickpleTypography(.title02_600)
                        .foregroundStyle(Color.black)
                    
                    Text(post.description)
                        .pickpleTypography(.body02_600)
                        .foregroundStyle(Color.neutral40)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 0) {
                HStack {
                    PostVoteCommentStats(type: post.type, voteCount: post.voteCount, commentCount: post.commentCount)
                        .pickpleTypography(.label_600)
                        .foregroundStyle(Color.neutral30)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        if let authorNickname = post.authorNickname {
                            HStack(spacing: 2) {
                                Text(authorNickname)
                                    .pickpleTypography(.caption_400) //폰트 미지정
                                    .foregroundStyle(Color.neutral40)
                                
                                if let authorLevel = post.authorLevel {
                                    Image("PickpleLevelBadge\(authorLevel)")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                            }
                            
                            Divider() //실제 디자인과 맞는지 확인 필요
                                .frame(height: 12)
                                .foregroundStyle(Color.navy10)
                        }
                        
                        Text(post.createdAt.relativeTimeDescription)
                            .pickpleTypography(.caption_400)// 폰트 미지정
                            .foregroundStyle(Color.neutral40)
                    }
                }
                .padding(.vertical, 16)
                Divider()
                    .foregroundStyle(Color.navy10)
            }
            }
        }
    }

    // A/B 카드 전용 — 기존 단일 사진 프레임(height 150, 전체 너비, radius 8) 하나를 반으로 나눠
    // displayOrder 1(A)을 왼쪽, 2(B)를 오른쪽에 배치한다. 두 장이 아니라 한 프레임처럼 보여야 해서
    // 틈 없이(spacing 0) 붙인다.
    private var abThumbnails: some View {
        HStack(spacing: 0) {
            productThumbnail(url: post.productImageUrl(displayOrder: 1))
            productThumbnail(url: post.productImageUrl(displayOrder: 2))
        }
        .frame(height: 150)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .clipped()
    }

    // 사진이 없는 상품 자리는 목업 사진 대신 빈 배경으로 둔다 — 없는 사진이 있는 것처럼 보이면 안 된다(API_SPEC 기준).
    @ViewBuilder
    private func productThumbnail(url: URL?) -> some View {
        if let url {
            thumbnailImage(url: url)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            Color.neutral10
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    // 서버 원본 사진이 리사이징 없이 그대로 오는 경우(수천 px대)가 있어서, AsyncImage를
    // .frame(maxWidth: .infinity)로만 제약하면 실기기에서 레이아웃이 원본 크기에 끌려가
    // 셀 밖으로 삐져나오는 문제가 있었다(프리뷰의 작은 목업 사진으로는 재현 안 됐음).
    // Color는 고유 크기 주장이 없어 부모가 주는 프레임을 그대로 따라간다 — 그 Color를
    // 주인공으로 두고 사진은 .overlay로 얹으면, overlay 콘텐츠는 주인공 크기에 맞춰질 뿐
    // 거꾸로 원본 크기가 바깥 레이아웃에 영향을 줄 수 없다.
    private func thumbnailImage(url: URL?) -> some View {
        Color.neutral10
            .overlay {
                PickpleAsyncImage(url: url, targetSize: CGSize(width: UIScreen.main.bounds.width, height: 150)) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Image("McokMyPostPicture").resizable().scaledToFill()
                }
            }
            .clipped()
    }
}

#Preview {
    CommunityPostCardView(
        post: PostSummary(
            id: 1,
            type: .forAgainst,
            category: "패션/잡화",
            title: "나이키 에어포스 흰색으로 살까?",
            description: "데일리로 신을건데 나이키 에어포스 흰색 어때? 흰색 때타고 별로이려나? 검은색은 이미 있어서 이번엔 흰 색도 사보려는데 어떻게 생각해?",
            thumbnailUrl: nil,
            authorNickname: "닉네임",
            authorLevel: 5,
            authorProfileImageUrl: nil,
            voteCount: 3,
            commentCount: 1,
            createdAt: Date().addingTimeInterval(-60 * 5)
        )
    )
    .padding()
}
