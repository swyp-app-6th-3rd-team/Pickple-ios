//
//  CarouselBottomKey.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//
//  캐러셀 아래쪽 끝의 y좌표(스크롤 좌표계 기준)를 전달하는 데 쓰는 PreferenceKey.

import SwiftUI

struct CarouselBottomKey: PreferenceKey {
    static var defaultValue: CGFloat = .infinity
    // 스크롤 콘텐츠의 다른 자식들도 전부 defaultValue(.infinity)를 암묵적으로 흘려보내므로,
    // "마지막 값 우선"으로 합치면 캐러셀이 설정한 실제 값이 뒤에서 덮어써진다.
    // .infinity를 min의 항등원으로 써서, 실제 값이 항상 이기도록 한다.
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = min(value, nextValue())
    }
}
