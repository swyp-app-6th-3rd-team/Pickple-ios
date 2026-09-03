//
//  PostDetailImageCarousel.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 캐러셀 높이/실시간 배지 아이콘(불꽃)은 임시값(전용 에셋 없음)

import SwiftUI

// 찬반/A-B 게시글 상세 상단의 사진 캐러셀. 뒤로가기·실시간 참여 인원·페이지 표시를 겹쳐서 보여준다.
struct PostDetailImageCarousel: View {
    let images: [String]
    let participantCount: Int
    @Binding var currentIndex: Int

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentIndex) {
                ForEach(Array(images.enumerated()), id: \.offset) { index, imageName in
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
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
                        .pickpleTypography(.body02)
                        .foregroundStyle(Color.white)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.black.opacity(0.4))
                .clipShape(Capsule())

                Spacer()

                Text("\(currentIndex + 1)/\(images.count)")
                    .pickpleTypography(.body02)
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
        }
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    PostDetailImageCarousel(
        images: ["McokMyPostPicture", "McokMyPostPicture"],
        participantCount: 3,
        currentIndex: .constant(0)
    )
}
