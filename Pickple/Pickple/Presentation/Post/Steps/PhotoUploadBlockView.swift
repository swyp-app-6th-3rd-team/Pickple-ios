//
//  PhotoUploadBlockView.swift
//  Pickple
//
//  Created by 박윤수 on 9/11/26.
//

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
        .sheet(isPresented: $showsPicker) {
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
