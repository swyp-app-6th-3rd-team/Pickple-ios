//
//  Profile.swift
//  Pickple
//
//  Created by 박윤수 on 8/27/26.
//
import SwiftUI
import PhotosUI

// 일단은 onCamera/offCamera 둘 다 탭하면 PhotosPicker가 열려서 사진을 수정할 수 있고,
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
    @Binding var selectedItem: PhotosPickerItem?
    
    let selectedImage: Image?
    let type: PickpleProfileType
    
    var body: some View {
        PhotosPicker(selection: $selectedItem) {
            profileCircle
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
                } else {
                    Circle()
                        .frame(width: 160, height: 160)
                        .foregroundStyle(Color.neutral20)
                }
            }
            .overlay {
                Circle()
                    .stroke(Color.blue10, lineWidth: 1)
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
                Image(systemName: "PickpleCamera")
                    .foregroundStyle(Color.neutral20)
                    
            }
            .overlay {
                Circle()
                    .stroke(Color.blue10, lineWidth: 1)
            }
    }
}

#Preview {
    @Previewable @State var selectedItem: PhotosPickerItem?

    VStack(spacing: 20) {
        // 사진 없음 + 카메라 배지
        PickpleProfile(selectedItem: $selectedItem, selectedImage: nil, type: .onCamera)

        // 사진 있음 + 카메라 배지
        PickpleProfile(selectedItem: $selectedItem, selectedImage: Image(systemName: "person.fill"), type: .onCamera)

        // 사진 없음 + 배지 없음
        PickpleProfile(selectedItem: $selectedItem, selectedImage: nil, type: .offCamera)
    }
}




