//
//  DescriptionFieldBlock.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  1차 점검 완료 - 9월 12일
// 작성되는 텍스트의 폰트와 색 확인 필요

import SwiftUI

// 포커스된 필드로 스크롤할 대상을 부모(ScrollViewReader가 있는 화면)에 알린다 — 중간에
// 몇 겹을 거치든(ForAgainstPostFieldSectionView 등) PreferenceKey는 그대로 위로 전달돼서,
// 그 화면들을 안 건드리고 이 필드와 최상위 화면만 알면 된다.
struct ScrollToFieldKey: PreferenceKey {
    static var defaultValue: String?
    static func reduce(value: inout String?, nextValue: () -> String?) {
        value = nextValue() ?? value
    }
}

// 글 작성 1단계에서 공통으로 쓰는 "설명" 라벨 + 여러 줄 입력 박스 + 글자 수 카운터.
struct DescriptionFieldBlock: View {
    @Binding var text: String
    let maxLength: Int

    @FocusState private var isFocused: Bool
    @State private var scrollTarget: String?
    private let fieldID = "descriptionField"

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(PostViewStrings.description)
                .pickpleTypography(.body01_500)
            
            ZStack(alignment: .top) {
                TextEditor(text: $text)
                    .pickpleTypography(.body01_400)
                    .foregroundStyle(Color.neutral100)
                    .scrollContentBackground(.hidden)
                    .frame(maxWidth: .infinity, minHeight: 180)
                    .focused($isFocused)
                    .padding(.horizontal, 10)
                    .padding(.top, 7)
                    .onChange(of: text) { _, newValue in
                        if newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Text("\(text.count)/\(maxLength)")
                            .pickpleTypography(.body02_400)
                            .foregroundStyle(Color.neutral40)
                            .padding(.trailing, 20)
                            .padding(.bottom, 15)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isFocused ? PickpleTextFieldStateType.ing.borderColor : Color.navy10, lineWidth: 1)
                    }
                
                if text.isEmpty {
                    Text(PostViewStrings.descriptionPlaceholder)
                        .pickpleTypography(.body01_400)
                        .foregroundStyle(Color.neutral40)
                        .allowsHitTesting(false)
                        .padding(.top, 15)

                }
            }
        }
        .id(fieldID)
        // 커서 위치가 아니라 이 필드 박스 자체를 기준으로 스크롤하기 위해, 포커스되는
        // 순간에만(그 이후 줄바꿈 등으로는 다시 안 쏨) 스크롤 대상 id를 위로 흘려보낸다.
        .onChange(of: isFocused) { _, newValue in
            scrollTarget = newValue ? fieldID : nil
        }
        .preference(key: ScrollToFieldKey.self, value: scrollTarget)
    }
}

#Preview {
    DescriptionFieldBlock(text: .constant(""), maxLength: 300)
}
