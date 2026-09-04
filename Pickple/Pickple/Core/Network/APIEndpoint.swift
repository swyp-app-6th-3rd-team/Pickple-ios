//
//  APIEndpoint.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import Foundation

enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

// 서버로 보낼 요청 하나의 명세. 각 도메인 Repository가 자신에게 필요한 엔드포인트를 이 타입으로 만들어 APIClient에 전달한다.
struct APIEndpoint: Sendable {
    let method: HTTPMethod
    let path: String
    var queryItems: [URLQueryItem] = []
    var body: Data? = nil
    var requiresAuth: Bool = false
}
