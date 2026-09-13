//
//  PickpleToast.swift
//  Pickple
//
//  Created by 박윤수 on 9/3/26.
//
//  1차 점검 완료 - 9월 13일
// 토스트 시간 물어봐야함
// 토스트 뜨는 위치는 어캐해야함

import SwiftUI

struct PickpleToast: View {
    let message: String

    var body: some View {
        Text(message)
            .pickpleTypography(.body02)
            .foregroundStyle(Color.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            .background(Color.black.opacity(0.6))
            .clipShape(Capsule())
    }
}

// 화면 하단에 잠깐 떴다가 자동으로 사라지는 토스트.
// isPresented가 true가 되면 durationSeconds 후 자동으로 false로 되돌린다.
struct PickpleToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    var durationSeconds: Double = 2

    func body(content: Content) -> some View {
        content.overlay(alignment: .bottom) {
            if isPresented {
                PickpleToast(message: message)
                    .padding(.bottom, 125)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .task {
                        try? await Task.sleep(nanoseconds: UInt64(durationSeconds * 1_000_000_000))
                        withAnimation {
                            isPresented = false
                        }
                    }
            }
        }
    }
}

extension View {
    func pickpleToast(isPresented: Binding<Bool>, message: String, durationSeconds: Double = 2) -> some View {
        modifier(PickpleToastModifier(isPresented: isPresented, message: message, durationSeconds: durationSeconds))
    }
}

#Preview {
    ZStack {
        Color.neutral5.ignoresSafeArea()
        PickpleToast(message: "게시글이 성공적으로 등록되었습니다")
    }
}
