//
//  NicknameAvailability.swift
//  Pickple
//
//  Created by 박윤수 on 9/5/26.
//

import Foundation

struct NicknameAvailability {
    let isAvailable: Bool
    // 서버가 "화면에 그대로 보여줄 안내"라고 명시한 문구라 그대로 노출한다.
    let message: String
}
