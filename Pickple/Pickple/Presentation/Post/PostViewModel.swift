//
//  PostViewModel.swift
//  Pickple
//
//  Created by 박윤수 on 8/29/26.
//

import Foundation
import Combine

enum VoteType: Equatable {
    case forAgainst
    case compare
    case text
}

class PostViewModel: ObservableObject {
    @Published var selectedType: VoteType = .forAgainst
    @Published var topic: String = ""
    @Published var selectedCategory: String = "카테고리를 선택하세요"

    let topicMaxLength = 30
    
    func isSelected(_ type: VoteType) -> Bool {
        selectedType == type
    }
}
