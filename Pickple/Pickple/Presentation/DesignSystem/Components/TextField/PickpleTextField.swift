//
//  PickpleTextField.swift
//  Pickple
//
//  Created by 박윤수 on 8/27/26.
//
//  TODO: 디자인 확정 후 변경 필요
//  - 폰트: "Nunito-ExtraBold" 하드코딩 → 폰트명/크기 확정 후 상수로 교체
//  - caption 문구("error", "success", "description") → 실제 문구로 교체
//

import SwiftUI

enum PickpleTextFieldAccessory {
    case none
    case text(String)
    case image(Image)
}

enum PickpleTextFieldType {
    case leading   // L
    case trailing  // R
    case both      // L+R

    var showLeadingAccessory: Bool {
        switch self {
        case .leading, .both: return true
        case .trailing: return false
        }
    }

    var showTrailingAccessory: Bool {
        switch self {
        case .trailing, .both: return true
        case .leading: return false
        }
    }
}

enum PickpleTextFieldStateType {
    case _default
    case ing
    case complete
    case error
    case success
    case description

    var caption: String {
        switch self {
        case ._default: return ""
        case .ing: return ""
        case .complete: return ""
        case .error: return "error"
        case .success: return "success"
        case .description: return "description"
        }
    }

    // _default는 기존 PickpleTextField가 쓰던 navy10을 그대로 유지 (이미 실제 화면에 쓰이고 있어서 시각적 변경 방지)
    var borderColor: Color {
        switch self {
        case ._default: return Color.navy10
        case .ing: return Color.black
        case .complete: return Color.blue10
        case .error: return Color.red60
        case .success: return Color.green60
        case .description: return Color.black
        }
    }

    var captionColor: Color {
        switch self {
        case ._default: return Color.clear
        case .ing: return Color.clear
        case .complete: return Color.clear
        case .error: return Color.red60
        case .success: return Color.green60
        case .description: return Color.neutral30
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
                .pickpleTypography(.body02)
                .foregroundStyle(Color.neutral40)
        case .image(let image):
            image
                .resizable()
                .frame(width: 20, height: 20)
        }
    }
}

struct PickpleTextField: View {
    @Binding var text: String

    // TODO: type과 leadingAccessory/trailingAccessory가 서로 안 맞게 넘어와도
    // 컴파일 에러 없이 조용히 빈 자리만 남는다 (예: type: .both인데 leadingAccessory 누락).
    // 호출부에서 항상 짝을 맞춰서 넘길 것. 나중에 여유 있으면 accessory의 .none 여부로
    // 노출을 판단하도록 바꿔서 type을 없애는 리팩토링 검토
    let type: PickpleTextFieldType
    let placeholder: String
    var leadingAccessory: PickpleTextFieldAccessory = .none
    var trailingAccessory: PickpleTextFieldAccessory = .none
    var state: PickpleTextFieldStateType = ._default

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 20) {
                if type.showLeadingAccessory {
                    PickpleTextFieldAccessoryView(accessory: leadingAccessory)
                }

                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        Text(placeholder)
                    }
                    TextField("", text: $text)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .foregroundStyle(Color.neutral100)
                    //실제 터치 영역 미변동 추후 확인 예정

                }
                .pickpleTypography(.body01)
                .foregroundStyle(Color.neutral40)

                if type.showTrailingAccessory {
                    PickpleTextFieldAccessoryView(accessory: trailingAccessory)
                }
            }
            .padding(.horizontal, 20)
            .frame(height: 56)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(state.borderColor, lineWidth: 1)
            }

            if !state.caption.isEmpty {
                Text(state.caption)
                    .pickpleTypography(.caption)
                    .foregroundStyle(state.captionColor)
                    .padding(.leading, 20)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        // L
        PickpleTextField(text: .constant(""), type: .leading, placeholder: "Text")

        // R
        PickpleTextField(text: .constant(""), type: .trailing, placeholder: "", trailingAccessory: .text("Text"))

        // L + R(text)
        PickpleTextField(text: .constant(""), type: .both, placeholder: "Text", trailingAccessory: .text("Text"))

        // L + R(image)
        PickpleTextField(text: .constant(""), type: .both, placeholder: "Text", trailingAccessory: .image(Image(systemName: "xmark.circle.fill")))

        // 상태별 (에러/성공/설명)
        PickpleTextField(text: .constant("error"), type: .leading, placeholder: "Text", state: .error)
        PickpleTextField(text: .constant("success"), type: .leading, placeholder: "Text", state: .success)
        PickpleTextField(text: .constant(""), type: .leading, placeholder: "Text", state: .description)
    }
    .padding()
}
