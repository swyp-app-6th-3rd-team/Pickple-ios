//
//  Profile.swift
//  Pickple
//
//  Created by 박윤수 on 8/27/26.
//
// 1차 점검 완료 - 9월 13일

import SwiftUI
import UIKit

// 일단은 onCamera/offCamera 둘 다 탭하면 사진 피커(CustomPhotoPickerView)가 열려서 사진을 수정할 수 있고,
// 카메라 배지 노출 여부만 다르다. 읽기 전용(다른 유저 프로필 등) 용도는 아직 없음.
// TODO: 실사용처가 정해지면 재검토 (읽기 전용 필요해지면 그때 분기 다시 추가)

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
                        .frame(width: 160, height: 160)
                        .clipShape(Circle())
                } else if let existingImageUrl {
                    AsyncImage(url: existingImageUrl) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Image("PickpleCharacter").resizable().scaledToFill()
                    }
                    .frame(width: 160, height: 160)
                    .clipShape(Circle())
                } else {
                    Image("PickpleCharacter")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 160)
                        .clipShape(Circle())
                        .foregroundStyle(Color.neutral20)
                }
            }
            .overlay {
                Circle()
                    .stroke(Color.navy10, lineWidth: 1)
            }

            if type.isCamera {
                cameraBadge
            }
        }
    }

    private var cameraBadge: some View {
        Circle()
            .frame(width: 40, height: 40)
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

        // 사진 있음 + 카메라 배지
        PickpleProfile(selectedImage: Image(systemName: "person.fill"), type: .onCamera, onSelect: { _ in })

        // 사진 없음 + 배지 없음
        PickpleProfile(selectedImage: nil, type: .offCamera, onSelect: { _ in })
    }
}




