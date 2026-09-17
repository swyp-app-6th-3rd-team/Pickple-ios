//
//  PostDetailImageCarousel.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  1차 점검 완료 - 9월 12일

import SwiftUI

// 찬반/A-B 게시글 상세 상단의 사진 캐러셀. 뒤로가기·실시간 참여 인원·페이지 표시를 겹쳐서 보여준다.
struct PostDetailImageCarousel: View {
    let images: [URL]
    let participantCount: Int
    @Binding var currentIndex: Int

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentIndex) {
                // TODO: CommunityPostCardView에서 겪은 것과 같은 위험 — 이 AsyncImage엔 명시적
                // frame이 없고 TabView 전체의 .frame(height: 280)에만 기대고 있다. 서버 원본이
                // 리사이징 없이 큰 사진(4000px대 확인됨)으로 오면 레이아웃이 원본 크기에 끌려갈
                // 수 있다. 재현되면 CommunityPostCardView처럼 Color+overlay로 감쌀 것.
                ForEach(Array(images.enumerated()), id: \.offset) { index, imageUrl in
                    AsyncImage(url: imageUrl) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Image("MockAgainstPicture").resizable().scaledToFill()
                    }
                    .tag(index)
                    .clipped()
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 280)

            HStack {
                HStack(spacing: 4) {
                    Image("PickpleFire")
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text("\(participantCount)명 투표중")
                        .pickpleTypography(.body02_600)
                        .foregroundStyle(Color.white)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.black.opacity(0.4))
                .clipShape(Capsule())

                Spacer()

                Text("\(currentIndex + 1)/\(images.count)")
                    .pickpleTypography(.body02_600)
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.4))
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)

            HStack(spacing: 4) {
                ForEach(0..<images.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.white : Color.white.opacity(0.4))
                        .frame(width: 6, height: 6)
                }
            }
            .padding(.bottom)
        }
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    PostDetailImageCarousel(
        images: [],
        participantCount: 3,
        currentIndex: .constant(0)
    )
}
