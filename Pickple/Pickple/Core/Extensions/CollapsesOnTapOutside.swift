//
//  CollapsesOnTapOutside.swift
//  Pickple
//
//  Created by 박윤수 on 10/2/26.
//
//  펼쳐진 드롭박스(정렬 버튼, 카테고리 드롭다운)를 화면 어디를 탭해도 접히게 한다.
//  컴포넌트는 자기 영역 밖의 탭을 받을 수 없어서, 탭을 받을 화면(또는 스크롤 영역)에 붙인다.
//  simultaneousGesture라 리스트 행·버튼의 탭과 스크롤을 막지 않아서, 펼쳐진 채로 게시글을
//  눌러도 닫기+이동이 한 번의 탭으로 끝난다. Spacer처럼 안 그려지는 빈 공간은 contentShape
//  없이는 히트테스트 영역이 아니라 탭 자체가 인식되지 않는다.
//  펼쳐진 드롭박스의 헤더는 탭을 받지 않게 해 두어서(allowsHitTesting), 헤더를 다시 누른
//  탭도 여기서 처리돼 닫힌다.

import SwiftUI

extension View {
    func collapsesOnTapOutside(_ isExpanded: Binding<Bool>) -> some View {
        contentShape(Rectangle())
            .simultaneousGesture(
                TapGesture().onEnded {
                    guard isExpanded.wrappedValue else { return }
                    withAnimation(.spring()) {
                        isExpanded.wrappedValue = false
                    }
                }
            )
    }
}
