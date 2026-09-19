//
//  PostDetailImageCarousel.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  1차 점검 완료 - 9월 12일

import SwiftUI
import UIKit

// 찬반/A-B 게시글 상세 상단의 사진 캐러셀. 뒤로가기·실시간 참여 인원·페이지 표시를 겹쳐서 보여준다.
struct PostDetailImageCarousel: View {
    let images: [URL]
    let participantCount: Int
    @Binding var currentIndex: Int
    @State private var scrollPosition: Int?

    var body: some View {
        ZStack(alignment: .bottom) {
            // TabView(.page)는 부모 세로 ScrollView와 팬 제스처가 충돌해 페이지 중간에서 멈추는 SwiftUI 버그가 있어 가로 ScrollView 페이징으로 우회.
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(Array(images.enumerated()), id: \.offset) { index, imageUrl in
                        PickpleAsyncImage(url: imageUrl, targetSize: CGSize(width: UIScreen.main.bounds.width, height: 280)) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Color.navy10
                        }
                        .frame(width: UIScreen.main.bounds.width, height: 280)
                        .clipped()
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .scrollPosition(id: $scrollPosition)
            .frame(height: 280)
            .onAppear { scrollPosition = currentIndex }
            .onChange(of: scrollPosition) { _, newValue in
                if let newValue { currentIndex = newValue }
            }
            .onChange(of: currentIndex) { _, newValue in
                if scrollPosition != newValue { scrollPosition = newValue }
            }

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
