//
//  PickPleTextFieldState.swift
//  Pickple
//
//  Created by 박윤수 on 8/27/26.
//
//  TODO: 디자인 확정 후 변경 필요
//  - 색상: borderColor(gray/blue/red/green/mint) → Asset Catalog 컬러셋으로 교체
//  - 폰트: "Nunito-ExtraBold" 하드코딩 → 폰트명/크기 확정 후 상수로 교체
//  - 사이즈: frame(width: 353, height: 56) 하드코딩 → 디자인 토큰으로 교체
//  - caption 문구("error", "success", "description") → 실제 문구로 교체
//

import SwiftUI

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
    
    var borderColor: Color {
        switch self {
        case ._default: return Color.blue10
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

struct PickpleTextFieldState: View {
    @Binding var nickname: String
    
    let type: PickpleTextFieldStateType
    let placeholder: String
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                if nickname.isEmpty {
                    Text(placeholder)
                        .font(.custom("Nunito-ExtraBold", size: 16)) //실제 폰트로 변경
                        .tracking(-0.02)
                        .lineSpacing(1.5)
                        .foregroundStyle(Color.gray)
                        .frame(width: 353, height: 56 ,alignment: .leading)
                        .padding(.leading, 12)
                }
                TextField("", text: $nickname)
                    .font(.custom("Nunito-ExtraBold", size: 16)) //실제 폰트로 변경
                    .tracking(-0.02)
                    .lineSpacing(1.5)
                    .foregroundStyle(Color.gray)
                    .frame(width: 353, height: 56, alignment: .leading)
                    .padding(.leading, 12)
                
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(type.borderColor, lineWidth: 1)
            }
            
            HStack {
                Text(type.caption)
                    .padding(.leading, 20)
                    .foregroundStyle(type.captionColor)
                Spacer()
            }
            
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        PickpleTextFieldState(nickname: .constant(""), type: ._default, placeholder: ProfileStrings.nicknameText)
        PickpleTextFieldState(nickname: .constant("complete"), type: .complete, placeholder: ProfileStrings.nicknameText)
        PickpleTextFieldState(nickname: .constant("description"), type: .description, placeholder: ProfileStrings.nicknameText)
        PickpleTextFieldState(nickname: .constant("error"), type: .error, placeholder: ProfileStrings.nicknameText)
        PickpleTextFieldState(nickname: .constant("ing"), type: .ing, placeholder: ProfileStrings.nicknameText)
        PickpleTextFieldState(nickname: .constant("success"), type: .success, placeholder: ProfileStrings.nicknameText)
    }
    
}






