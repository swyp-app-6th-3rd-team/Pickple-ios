//
//  PickpleSortButton.swift
//  Pickple
//
//  Created by 박윤수 on 9/2/26.
//
//  TODO: 기능(실제 정렬 적용) 미구현 — UI만 우선 작업

import SwiftUI

struct PickpleSortButton: View {
    @Binding var isExpanded: Bool
    @Binding var selectedValue: String
    
    let options: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(action: {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 2) {
                    Text(selectedValue)
                        .pickpleTypography(.body02)
                        .foregroundStyle(Color.neutral50)

                    Image("PickpleArrowFill")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color.neutral30)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
            }
            
            if isExpanded {
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
                                    .pickpleTypography(.body01)
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
                .shadow(color: Color.white, radius: 10)
                
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
