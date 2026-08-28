//
//  PickpleTextField.swift
//  Pickple
//
//  Created by 박윤수 on 8/27/26.
//
//  TODO: 디자인 확정 후 변경 필요
//  - 색상: borderColor(Color.gray) → Asset Catalog 컬러셋으로 교체
//  - 폰트: "Nunito-ExtraBold" 하드코딩 → 폰트명/크기 확정 후 상수로 교체
//  - 사이즈: frame(width: 353, height: 56) 하드코딩 → 디자인 토큰으로 교체
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

struct PickpleTextFieldAccessoryView: View {
    let accessory: PickpleTextFieldAccessory

    var body: some View {
        switch accessory {
        case .none:
            EmptyView()
        case .text(let text):
            Text(text)
                .font(.custom("Nunito-ExtraBold", size: 16)) //실제 폰트로 변경
                .foregroundStyle(Color.gray)
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
    // 노출을 판단하도록 바꿔서 type을 없애는 리팩터링 검토
    let type: PickpleTextFieldType
    let placeholder: String
    var leadingAccessory: PickpleTextFieldAccessory = .none
    var trailingAccessory: PickpleTextFieldAccessory = .none

    var body: some View {
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
                //실제 터치 영역 미변동 추후 확인 예정
                    
            }
            .font(.custom("Nunito-ExtraBold", size: 16)) //실제 폰트로 변경
            .tracking(-0.02)
            .lineSpacing(1.5)
            .foregroundStyle(Color.neutral40)

            if type.showTrailingAccessory {
                PickpleTextFieldAccessoryView(accessory: trailingAccessory)
            }
        }
        .padding(.horizontal, 20)
        .frame(width: 353, height: 56)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue10, lineWidth: 1)
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
    }
}
