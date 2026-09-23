//
//  Profile.swift
//  Pickple
//
//  Created by 박윤수 on 8/27/26.
//
// 1차 점검 완료 - 9월 13일

import SwiftUI
import UIKit

enum PickpleProfileType {
    case onCamera
    case offCamera
    
    var isCamera: Bool {
        switch self {
        case .onCamera: return true
        case .offCamera: return false
        }
    }
}

struct PickpleProfile: View {
    let selectedImage: Image?
    let type: PickpleProfileType
    let onSelect: (UIImage) -> Void
    // 새로 고른 사진(selectedImage)이 없을 때 대신 보여줄, 서버에 이미 저장된 프로필 사진.
    var existingImageUrl: URL? = nil
    
    @State private var showsPicker = false
    
    var body: some View {
        Button(action: { showsPicker = true }) {
            profileCircle
        }
        .sheet(isPresented: $showsPicker) {
            CustomPhotoPickerView(onSelect: { images in
                guard let image = images.first else { return }
                onSelect(image)
            })
        }
    }
    
    private var profileCircle: some View {
        ZStack(alignment: .bottomTrailing) {
            Group {
                if let image = selectedImage {
                    image
                        .resizable()
                        .frame(width: 124, height: 124)
                        .clipShape(Circle())
                } else if let existingImageUrl {
                    PickpleAsyncImage(url: existingImageUrl, targetSize: CGSize(width: 124, height: 124)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Circle()
                            .foregroundStyle(Color.gray)
                    }
                    .frame(width: 124, height: 124)
                    .clipShape(Circle())
                } else {
                    Image("PickpleCharacter")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 124, height: 124)
                        .clipShape(Circle())
                }
            }
            .overlay {
                Circle()
                    .stroke(Color.navy10, lineWidth: 1)
            }
            cameraBadge
        }
    }
    
    //MARK: - camerBadge
    private var cameraBadge: some View {
        Circle()
            .frame(width: 32, height: 32)
            .foregroundStyle(Color.white)
            .overlay {
                Image("PickpleCamera")
                    .foregroundStyle(Color.neutral20)
            }
            .overlay {
                Circle()
                    .stroke(Color.navy10, lineWidth: 1)
            }
    }
}

#Preview {
    VStack(spacing: 20) {
        // 사진 없음 + 카메라 배지
        PickpleProfile(selectedImage: nil, type: .onCamera, onSelect: { _ in })
    }
}




