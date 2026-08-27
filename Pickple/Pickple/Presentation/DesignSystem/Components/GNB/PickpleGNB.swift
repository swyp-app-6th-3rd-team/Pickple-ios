//
//  PickpleGNB.swift
//  Pickple
//
//  Created by 박윤수 on 8/27/26.
//
//  TODO: 디자인 확정 후 변경 필요
//  - 폰트: Text(type.title)에 폰트 적용 필요 (현재 시스템 기본 폰트)
//  - 아이콘: leading/trailing 버튼에 실제 아이콘 추가 필요 (현재 빈 버튼)
//

import SwiftUI

enum PickpleGNBTitleAlignment {
    case leading   // 좌측 정렬
    case center    // 중앙 정렬
}

enum PickpleGNBType {
    case backGNB
    case alertGNB
    case searchGNB
    
    var title: String {
        switch self {
        case .backGNB: return GNBStrings.backTitle
        case .alertGNB: return GNBStrings.alertTitle
        case .searchGNB: return GNBStrings.searchTitle
        }
    }
    
    var titleAlignment: PickpleGNBTitleAlignment {
        switch self {
        case .backGNB: return .center
        case .alertGNB: return .leading
        case .searchGNB: return .leading
        }
    }
    
    var showLeadingButton: Bool {
        switch self {
        case .backGNB: return true
        case .alertGNB: return true
        case .searchGNB: return true
        }
    }
    
    var showTrailingButton: Bool {
        switch self {
        case .backGNB: return false
        case .alertGNB: return true
        case .searchGNB: return true
        }
    }
}

struct PickpleGNB: View {
    let type: PickpleGNBType
    let onLeadingTap: (() -> Void)?
    let onTrailingTap: (() -> Void)?

    var body: some View {
        HStack {
            //Leading Button 유/무
            if type.showLeadingButton {
                Button(action: { onLeadingTap?() }) { /* 뒤로가기 아이콘 */ }
            } else {
                Color.clear.frame(width: 24)
            }
            
            // title 위치
            if type.titleAlignment == .leading {
                Text(type.title)
                Spacer()
            } else {
                Spacer()
                Text(type.title)
                Spacer()
            }
            
            //TrailingButton 유/무
            if type.showTrailingButton {
                Button(action: { onTrailingTap?() }) { /* 알림 아이콘 */ }
            } else {
                Color.clear.frame(width: 24)
            }
        }
    }
}

