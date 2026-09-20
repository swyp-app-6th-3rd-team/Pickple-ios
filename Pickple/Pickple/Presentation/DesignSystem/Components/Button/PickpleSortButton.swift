//
//  PickpleSortButton.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//
// 1차 점검 완료 - 9월 12일

import SwiftUI

struct PickpleSortButton: View {
    @Binding var isExpanded: Bool
    @Binding var selectedValue: String

    let options: [String]
    var alignment: HorizontalAlignment = .leading
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
        VStack(alignment: alignment, spacing: 4) {
            Button(action: {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 2) {
                    Text(selectedValue)
                        .pickpleTypography(.body02_600)
                        .foregroundStyle(Color.neutral50)

                    Image("PickpleArrowFill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.neutral30)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selectedValue = option
                            isCollapsing = true
                            withAnimation(.spring()) {
                                isExpanded = false
                            } completion: {
                                isCollapsing = false
                            }
                        }) {
                            HStack {
                                Text(option)
                                    .pickpleTypography(.body01_500)
                                    .foregroundStyle(Color.neutral70)

                                Spacer()

                                if option == selectedValue {
                                    Image("PickpleCheck")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .foregroundStyle(Color.neutral70)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                        }
                    }
                }
                .allowsHitTesting(!isCollapsing)
                .frame(width: 162, height: 96)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        
                        .stroke(Color.navy10, lineWidth: 1)
                    
                }
                .shadow(color: Color.black.opacity(0.1), radius: 10)
                
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var isExpanded = false
        @State private var selectedValue = "최신순"

        var body: some View {
            PickpleSortButton(
                isExpanded: .constant(false),
                selectedValue: .constant(selectedValue),
                options: ["최신순", "오래된 순"]
            )
            .floatingOverSiblings {
                PickpleSortButton(
                    isExpanded: $isExpanded,
                    selectedValue: $selectedValue,
                    options: ["최신순", "오래된 순"]
                )
            }
        }
    }
    return PreviewWrapper()
}
