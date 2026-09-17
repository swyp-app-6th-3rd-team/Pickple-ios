//
//  PhotoUploadBlockView.swift
//  Pickple
//
//  Created by 박윤수 on 9/11/26.
// 1차 점검 완료 - 9월 12일

import SwiftUI

struct PhotoUploadBlockView: View {
    @State private var showsPicker = false

    @Binding var photos: [UIImage]

    let maxCount: Int

    var isDisabled: Bool = false

    var body: some View {
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
                        Image("PickpleX")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color.white)
                            .padding(6)
                            .background(
                                Circle()
                                    .foregroundStyle(Color.neutral80)
                                    .padding(4)
                                    .background(
                                        Circle()
                                            .foregroundStyle(Color.white)
                                    )
                            )
                    }
                    .offset(x: -4, y: -9)
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
        // .sheet를 쓰면 직전에 포커스돼 있던 텍스트필드(상품명 등)의 키보드가 채 안 내려간 상태로
        // present와 겹쳐서 열리자마자 바로 dismiss돼버렸다. fullScreenCover로 바꿔서 해결.
        .fullScreenCover(isPresented: $showsPicker) {
            CustomPhotoPickerView(
                selectionLimit: maxCount - photos.count,
                onSelect: { images in photos.append(contentsOf: images) }
            )
        }
        .disabled(isDisabled)
    }

}


#Preview {
    PhotoUploadBlockView(photos: .constant([]), maxCount: 3)
}
