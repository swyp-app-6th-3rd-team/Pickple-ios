//
//  MainToggleButton.swift
//  Pickple
//
//  Created by 박윤수 on 9/5/26.
// 1차 점검 완료 - 9월 12일
// 폰트 수정 예정

import SwiftUI

struct MainToggleButton: View {
    @Binding var selectedType: VoteType
    
    private let speed: Double = 0.1

    // 선택 캡슐이 두 버튼 사이를 슬라이딩하는 것처럼 보이게 하려면, 서로 다른 두 위치의
    // Capsule을 같은 id로 표시해서 SwiftUI가 하나의 도형이 이동하는 것으로 보간하게 한다.
    @Namespace private var selectionNamespace

    var body: some View {
            HStack(spacing: -4) {
                Button(action: { selectedType = .forAgainst }) {
                    Text(MainStrings.abToggleOffTitle)
                        .pickpleTypography(.body02_600)
                        .foregroundStyle(selectedType == .forAgainst ? Color.yellow60 : Color.neutral20)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background {
                            if selectedType == .forAgainst {
                                Capsule()
                                    .foregroundStyle(Color.navy60)
                                    .matchedGeometryEffect(id: "selection", in: selectionNamespace)
                            }
                        }
                }
                

                Button(action: { selectedType = .ab })
                {
                    Text(MainStrings.abToggleOnTitle)
                        .pickpleTypography(.body02_600)
                        .foregroundStyle(selectedType == .ab ? Color.yellow60 : Color.neutral20)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background {
                            if selectedType == .ab {
                                Capsule()
                                    .foregroundStyle(Color.navy60)
                                    .matchedGeometryEffect(id: "selection", in: selectionNamespace)
                            }
                        }
                }
            }
            .padding(2)
            .background(
                Capsule()
                    .foregroundStyle(Color.neutral5)
            )
        
        .animation(.easeInOut(duration: speed), value: selectedType)
    }
}

#Preview {
    @Previewable @State var selectedType: VoteType = .ab
    MainToggleButton(selectedType: $selectedType)
}

