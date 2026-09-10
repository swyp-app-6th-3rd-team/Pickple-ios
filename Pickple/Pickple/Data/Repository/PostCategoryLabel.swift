//
//  PostCategoryLabel.swift
//  Pickple
//
//  Created by 박윤수 on 9/7/26.
//

import Foundation

// 서버 카테고리 코드 → 한글 라벨 매핑. Remote*Repository들이 각자 중복 구현하지 않도록 공용으로 뺐다.
enum PostCategoryLabel {
    static func label(for rawCategory: String) -> String {
        switch rawCategory {
        case "FASHION": return "패션/잡화"
        case "ELECTRONICS": return "전자제품"
        case "BEAUTY": return "뷰티"
        case "LIVING": return "생활용품"
        default: return "기타"
        }
    }

    // 커뮤니티 화면에서 고른 한글 라벨을 GET /posts의 category 쿼리 파라미터로 되돌린다.
    // "전체"는 필터 없음을 뜻하므로 nil.
    static func code(for label: String) -> String? {
        switch label {
        case "패션/잡화": return "FASHION"
        case "전자제품": return "ELECTRONICS"
        case "뷰티": return "BEAUTY"
        case "생활용품": return "LIVING"
        case "기타": return "ETC"
        default: return nil
        }
    }
}
