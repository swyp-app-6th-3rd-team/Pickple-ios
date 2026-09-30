//
//  APIEnvironment.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import Foundation

enum APIEnvironment {
    static let devBaseURL: URL = {
        guard let url = URL(string: "https://dev-api.pickple.app") else {
            fatalError("APIEnvironment.devBaseURL이 유효한 URL이 아닙니다")
        }
        return url
    }()
}
