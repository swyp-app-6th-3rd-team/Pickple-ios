//
//  MainToggleButton.swift
//  Pickple
//
//  Created by 박윤수 on 9/5/26.
// 1차 수정 완료 9월 12일

import SwiftUI

struct MainToggleButton: View {
    @Binding var isOn: Bool
    let onTitle: String
    let offTitle: String
    
    private let width: CGFloat = 96
    private let height: CGFloat = 32
    private let speed: Double = 0.2

    // 선택 캡슐이 두 버튼 사이를 슬라이딩하는 것처럼 보이게 하려면, 서로 다른 두 위치의
    // Capsule을 같은 id로 표시해서 SwiftUI가 하나의 도형이 이동하는 것으로 보간하게 한다.
    @Namespace private var selectionNamespace

    var body: some View {
        ZStack(alignment: .center) {
            //배경 캡슐
            Capsule()
                .foregroundStyle(Color.neutral5)
                .frame(width: 96, height: 32)

            HStack(spacing: -4) {
                Button(action: { isOn = false }) {
                    Text(onTitle)
                        .pickpleTypography(.body02)

                        .foregroundStyle(isOn ? Color.neutral20 : Color.yellow60)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background {
                            if !isOn {
                                Capsule()
                                    .foregroundStyle(Color.navy60)
                                    .matchedGeometryEffect(id: "selection", in: selectionNamespace)
                            }
                        }
                }

                Button(action: { isOn = true })
                {
                    Text(offTitle)
                        .pickpleTypography(.body02)
                        .foregroundStyle(isOn ? Color.yellow60 : Color.neutral20)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background {
                            if isOn {
                                Capsule()
                                    .foregroundStyle(Color.navy60)
                                    .matchedGeometryEffect(id: "selection", in: selectionNamespace)
                            }
                        }
                }
            }
        }
        .animation(.easeInOut(duration: speed), value: isOn)
        .frame(width: width, height: height)
    }
}

#Preview {
    @Previewable @State var isOn = false
    MainToggleButton(isOn: $isOn, onTitle: "찬반", offTitle: "AB")
}

