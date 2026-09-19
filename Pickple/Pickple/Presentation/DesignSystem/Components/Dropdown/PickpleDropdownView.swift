//
//  PickpleDropdownView.swift
//  Pickple
//
//  Created by 박윤수 on 8/29/26.
//
// 1차 점검 완료 9월 12일

import SwiftUI

struct PickpleDropdownView: View {
    @Binding var isExpanded: Bool
    @Binding var selectedValue: String

    let options: [String]
    // 리스트가 접히는 도중엔(헤더를 다시 눌러 닫든, 화면 배경을 탭해서 닫든) 옵션 버튼이
    // 여전히 화면에 남아 탭을 그대로 받아버려서 엉뚱한 항목이 선택되는 문제가 있었다.
    // isExpanded가 꺼지는 순간(트리거가 어디서 왔든) onChange로 감지해 isCollapsing을
    // 세우고, 옵션 버튼 action 안에서 guard로 막는다 — action은 렌더링이 아니라 탭이
    // 눌리는 시점에 실행되므로 애니메이션 타이밍과 무관하게 항상 최신 상태를 본다.
    // 헤더 버튼은 값을 잘못 선택할 위험이 없어 가드를 걸지 않는다 — 걸면 닫힌 뒤
    // isCollapsing이 풀리기 전까진 재오픈 토글 자체가 막혀버린다(isExpanded가 바뀌어야
    // onChange가 풀어주는데, 그 토글을 가드가 먼저 막아버리는 순환 문제).
    @State private var isCollapsing = false

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
                        .pickpleTypography(.body01_400)
                        .foregroundStyle(selectedValue == PostViewStrings.categoryPlaceholder ? Color.neutral40 : Color.black)
                        
                    Spacer()
                    Image("PickpleArrowDown")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.neutral40)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.horizontal, 21)
                .frame(maxWidth: .infinity, minHeight: 56)
            }

            // 펼쳐지는 리스트 영역
            if isExpanded {
                Divider()
                    .foregroundStyle(Color.navy10)

                VStack(alignment: .leading, spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            guard !isCollapsing else { return }
                            selectedValue = option
                            withAnimation(.spring()) {
                                isExpanded = false
                            }
                        }) {
                            Text(option)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 14)
                        }
                        .foregroundColor(.neutral80)

                        if option != options.last {
                            Divider()
                                .foregroundStyle(Color.navy10)
                        }
                    }
                    .padding(.horizontal, 16)

                }
                .allowsHitTesting(!isCollapsing)
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.navy10, lineWidth: 1)
        }
        .onChange(of: isExpanded) { oldValue, newValue in
            if newValue {
                isCollapsing = false
            } else if oldValue {
                isCollapsing = true
            }
        }
    }
}

extension View {
    /// 이 뷰(접힌 상태 기준 콘텐츠)로 레이아웃 공간만 고정해서 차지하고,
    /// 실제로 보여줄(펼쳐지면 더 커질 수 있는) 콘텐츠는 그 위에 overlay로 겹쳐서 그린다.
    /// 펼쳐졌을 때 형제 뷰를 밀어내지 않으면서, zIndex로 그 위에 표시되게 한다.
    func floatingOverSiblings<Content: View>(
        alignment: Alignment = .topLeading,
        zIndex: Double = 1,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self
            .hidden()
            .allowsHitTesting(false)
            .overlay(alignment: alignment, content: content)
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
