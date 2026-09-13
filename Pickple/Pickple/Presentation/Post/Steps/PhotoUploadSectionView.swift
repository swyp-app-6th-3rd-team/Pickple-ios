//
//  PhotoUploadFieldBlock.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
// 1차 점검 완료 - 9월 12일
//
//  TODO: 디자인 확정 후 변경 필요 — 업로드 슬롯 아이콘은 시스템 아이콘으로 임시 대체(전용 에셋 없음)

import SwiftUI

// 상품 정보 단계에서 공통으로 쓰는 사진 업로드 슬롯(최대 N장, 추가/삭제).
// 시스템 PhotosPicker 대신 커스텀 포토피커(CustomPhotoPickerView, ComparisonPhotoFieldBlock과
// 동일 패턴)를 쓴다 — 한 번에 한 장씩 골라 추가한다.
struct PhotoUploadSectionView: View {
    @Binding var photos: [UIImage]
    let maxCount: Int
    let hintText: String
    var isDisabled: Bool = false
    
    @State private var showsPicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            PhotoUploadTitleView(hintText: hintText)

            PhotoUploadBlockView(photos: $photos, maxCount: maxCount, isDisabled: isDisabled)
        }
        .opacity(isDisabled ? 0.5 : 1)
    }
}

#Preview {
    PhotoUploadSectionView(photos: .constant([]), maxCount: 3, hintText: PostViewStrings.photoHintUpToThree)
}
