//
//  ComparisonPhotoFieldBlock.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//
//  A/B 비교 픽 전용 사진 섹션 — 상품A/B 사진을 한 칸씩, 나란히 두 칸으로 보여준다.
//  시스템 PhotosPicker 대신 커스텀 포토피커(CustomPhotoPickerView, PickpleProfile과 동일 패턴)를 쓴다.

import SwiftUI

struct ComparisonPhotoFieldBlock: View {
    @Binding var photoA: [UIImage]
    @Binding var photoB: [UIImage]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            (Text(PostViewStrings.photo) + Text(" ") + Text(PostViewStrings.requiredMark).foregroundStyle(Color.red60))
                .pickpleTypography(.body01)

            HStack(spacing: 8) {
                ComparisonPhotoSlot(photos: $photoA, label: PostViewStrings.abOptionALabel)
                ComparisonPhotoSlot(photos: $photoB, label: PostViewStrings.abOptionBLabel)
            }
        }
    }
}

private struct ComparisonPhotoSlot: View {
    // 한 칸에 정확히 한 장만 담기지만, PostProductDraft.photos가 [UIImage]라 타입을 맞춘다.
    @Binding var photos: [UIImage]
    let label: String

    @State private var showsPicker = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let image = photos.first {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 96, height: 96)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .clipped()

                Button(action: { photos = [] }) {
                    Image("PickpleClose")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .padding(6)
                        .background(Circle().foregroundStyle(Color.white))
                }
                .padding(4)
            } else {
                Button(action: { showsPicker = true }) {
                    VStack(spacing: 4) {
                        Image("PickplePhoto")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.neutral20)

                        Text(label)
                            .pickpleTypography(.caption)
                            .foregroundStyle(Color.neutral20)
                    }
                    .frame(width: 96, height: 96)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4]))
                            .foregroundStyle(Color.neutral20)
                    }
                }
            }
        }
        .sheet(isPresented: $showsPicker) {
            CustomPhotoPickerView(onSelect: { images in
                guard let image = images.first else { return }
                photos = [image]
            })
        }
    }
}

#Preview {
    ComparisonPhotoFieldBlock(photoA: .constant([]), photoB: .constant([]))
        .padding()
}
