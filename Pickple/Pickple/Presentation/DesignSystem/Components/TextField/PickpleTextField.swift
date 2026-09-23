//
//  PickpleTextField.swift
//  Pickple
//
//  Created by 박윤수 on 8/27/26.
//
// 1차 점검 완료 - 9월 13일

import SwiftUI

enum PickpleTextFieldAccessory: Equatable {
    case none
    case text(String)
}

enum PickpleTextFieldStateType: Equatable {
    case _default
    case ing
    case error
    case success
    
    var borderColor: Color {
        switch self {
        case ._default: return Color.navy10
        case .ing: return Color.black
        case .error: return Color.red60
        case .success: return Color.green60
        }
    }
    
    var captionColor: Color {
        switch self {
        case .error: return Color.red60
        case .success: return Color.green60
        default: return Color.clear
            
        }
    }
    
    // 캡션은 에러/성공 상태에서만 의미가 있다 — 호출부가 다른 상태에서 caption을
    // 실수로 비워서 안 넘겨도(또는 빈 문자열이 아니어도), 여기서 한 번 더 막아서
    // 투명한 텍스트가 자리(spacing+줄 높이)만 차지하는 걸 방지한다.
    var showsCaption: Bool {
        switch self {
        case .error, .success: return true
        case ._default, .ing: return false
        }
    }
}

struct PickpleTextFieldAccessoryView: View {
    let accessory: PickpleTextFieldAccessory
    
    var body: some View {
        switch accessory {
        case .none:
            EmptyView()
        case .text(let text):
            Text(text)
                .pickpleTypography(.body02_600)
                .foregroundStyle(Color.neutral40)
        }
    }
}

struct PickpleTextField: View {
    @Binding var text: String
    
    let placeholder: String
    var trailingAccessory: PickpleTextFieldAccessory = .none
    var title: String = ""
    var caption: String = ""
    var state: PickpleTextFieldStateType = ._default
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            if !title.isEmpty {
                Text(title)
                    .pickpleTypography(.body02_600)
                    .foregroundStyle(Color.neutral100)
                    .padding(.horizontal, 4)
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    ZStack(alignment: .leading) {
                        if text.isEmpty {
                            Text(placeholder)
                        }
                        TextField("", text: $text)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 24)
                            .foregroundStyle(Color.neutral100)
                    }
                    .pickpleTypography(.body01_500)
                    .foregroundStyle(Color.neutral40)
                    
                    Spacer()
                    
                    if trailingAccessory != .none {
                        PickpleTextFieldAccessoryView(accessory: trailingAccessory)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(state.borderColor, lineWidth: 1)
                }
                
                if state.showsCaption, !caption.isEmpty {
                    Text(caption)
                        .foregroundStyle(state.captionColor)
                        .padding(.horizontal, 4)
                }
            }
            
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        // 액세서리 없음
        PickpleTextField(text: .constant(""), placeholder: "Text")
        
        // 트레일링 텍스트 액세서리
        PickpleTextField(text: .constant(""), placeholder: "", trailingAccessory: .text("Text"))
        
        // 상태별 (에러/성공/설명)
        PickpleTextField(text: .constant("error"), placeholder: "Text", caption: "error", state: .error)
        
        PickpleTextField(text: .constant("success"), placeholder: "Text", caption: "success", state: .success)
        
        PickpleTextField(text: .constant("success"), placeholder: "Text", title: "test")
    }
}
