//
//  PhotoUploadFieldBlock.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  TODO: 디자인 확정 후 변경 필요 — 업로드 슬롯 아이콘은 시스템 아이콘으로 임시 대체(전용 에셋 없음)

import SwiftUI

// 상품 정보 단계에서 공통으로 쓰는 사진 업로드 슬롯(최대 N장, 추가/삭제).
// 시스템 PhotosPicker 대신 커스텀 포토피커(CustomPhotoPickerView, ComparisonPhotoFieldBlock과
// 동일 패턴)를 쓴다 — 한 번에 한 장씩 골라 추가한다.
struct PhotoUploadFieldBlock: View {
    @Binding var photos: [UIImage]
    let maxCount: Int
    let hintText: String

    @State private var showsPicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            (Text(PostViewStrings.photo) + Text(" ") + Text(PostViewStrings.requiredMark).foregroundStyle(Color.red60))
                .pickpleTypography(.body01)

            Text(hintText)
                .pickpleTypography(.body02)
                .foregroundStyle(Color.neutral40)

            HStack(spacing: 8) {
                ForEach(Array(photos.enumerated()), id: \.offset) { index, image in
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 96, height: 96)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .clipped()

                        Button(action: { photos.remove(at: index) }) {
                            Image("PickpleClose")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .padding(6)
                                .background(Circle().foregroundStyle(Color.white))
                        }
                        .padding(4)
                    }
                }

                if photos.count < maxCount {
                    Button(action: { showsPicker = true }) {
                        VStack(spacing: 4) {
                            Image("PickplePhoto")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(Color.neutral20)

                            Text("\(photos.count)/\(maxCount)")
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
        }
        .sheet(isPresented: $showsPicker) {
            CustomPhotoPickerView(
                selectionLimit: maxCount - photos.count,
                onSelect: { images in photos.append(contentsOf: images) }
            )
        }
    }
}

#Preview {
    PhotoUploadFieldBlock(photos: .constant([]), maxCount: 3, hintText: PostViewStrings.photoHintUpToThree)
}
