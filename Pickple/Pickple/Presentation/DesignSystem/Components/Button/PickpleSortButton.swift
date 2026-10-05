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

    var body: some View {
        headerLabel
            .floatingOverSiblings(alignment: overlayAlignment) {
                VStack(alignment: alignment, spacing: 4) {
                    headerButton
                    // if로 넣고 빼면 사라지는 애니메이션 동안 목록이 닫히기 직전 상태로 얼어서 탭을
                    // 받는다 — 항상 그려두고 숨겨야 allowsHitTesting이 닫히는 순간 바로 반영된다.
                    optionList
                        .opacity(isExpanded ? 1 : 0)
                        .allowsHitTesting(isExpanded)
                        .accessibilityHidden(!isExpanded)
                }
            }
    }

    private var overlayAlignment: Alignment {
        switch alignment {
        case .trailing: return .topTrailing
        case .center: return .top
        default: return .topLeading
        }
    }

    private var headerButton: some View {
        Button(action: {
            withAnimation(.spring()) {
                isExpanded.toggle()
            }
        }) {
            headerLabel
        }
        // 펼쳐진 동안엔 헤더가 탭을 받지 않아서, 다시 누른 탭은 화면의 collapsesOnTapOutside가
        // 받아 닫는다 — 헤더도 같이 받으면 바깥 탭이 닫은 걸 toggle()이 다시 열어버린다.
        .allowsHitTesting(!isExpanded)
    }

    private var optionList: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selectedValue = option
                    withAnimation(.spring()) {
                        isExpanded = false
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
        .frame(width: 162, height: 96)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                
                .stroke(Color.navy10, lineWidth: 1)
            
        }
        .shadow(color: Color.black.opacity(0.1), radius: 10)
    }

    private var headerLabel: some View {
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
}

#Preview {
    struct PreviewWrapper: View {
        @State private var isExpanded = false
        @State private var selectedValue = "최신순"

        var body: some View {
            PickpleSortButton(
                isExpanded: $isExpanded,
                selectedValue: $selectedValue,
                options: ["최신순", "오래된 순"]
            )
        }
    }
    return PreviewWrapper()
}
