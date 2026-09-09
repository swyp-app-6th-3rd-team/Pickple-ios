//
//  CustomPhotoPickerStrings.swift
//  Pickple
//
//  Created by 박윤수 on 9/6/26.
//

enum CustomPhotoPickerStrings {
    static let navigationTitle = "사진"
    static let cancel = "취소"
    static let permissionDeniedMessage = "설정에서 사진 접근을 허용해주세요"

    static func done(_ selectedCount: Int) -> String {
        selectedCount > 0 ? "완료(\(selectedCount))" : "완료"
    }
}
