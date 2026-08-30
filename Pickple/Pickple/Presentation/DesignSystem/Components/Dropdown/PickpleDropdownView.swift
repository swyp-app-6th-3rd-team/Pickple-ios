//
//  PickpleDropdownView.swift
//  Pickple
//
//  Created by 박윤수 on 8/29/26.
//

import SwiftUI

struct PickpleDropdownView: View {
    @Binding var isExpanded: Bool
    @Binding var selectedValue: String

    let options: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 드롭다운 버튼 영역
            Button(action: {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selectedValue)
                        .foregroundStyle(Color.neutral40)
                        .padding(.leading, 21)
                    Spacer()
                    Image("PickpleArrowUp")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .padding(.trailing, 21)
                }
                .frame(maxWidth: .infinity, minHeight: 56)
            }

            // 펼쳐지는 리스트 영역
            if isExpanded {
                Divider()

                VStack(alignment: .leading, spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selectedValue = option
                            withAnimation(.spring()) {
                                isExpanded = false
                            }
                        }) {
                            Text(option)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                        }
                        .foregroundColor(.neutral80)

                        if option != options.last {
                            Divider()
                                .padding(.horizontal, 16)
                        }
                    }
                }
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.navy10, lineWidth: 1)
        }
        .padding(.horizontal, 20)
    }
}

extension View {
    /// 이 뷰(접힌 상태 기준 콘텐츠)로 레이아웃 공간만 고정해서 차지하고,
    /// 실제로 보여줄(펼쳐지면 더 커질 수 있는) 콘텐츠는 그 위에 overlay로 겹쳐서 그린다.
    /// 펼쳐졌을 때 형제 뷰를 밀어내지 않으면서, zIndex로 그 위에 표시되게 한다.
    func floatingOverSiblings<Content: View>(
        zIndex: Double = 1,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self
            .hidden()
            .allowsHitTesting(false)
            .overlay(alignment: .top, content: content)
            .zIndex(zIndex)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var isExpanded = false
        @State private var selectedValue = "카테고리를 선택하세요"

        var body: some View {
            PickpleDropdownView(
                isExpanded: $isExpanded,
                selectedValue: $selectedValue,
                options: ["패션/잡화", "전자제품", "화장품/뷰티", "생활용품", "기타"]
            )
        }
    }
    return PreviewWrapper()
}
