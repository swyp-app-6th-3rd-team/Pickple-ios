//
//  APIError.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import Foundation

enum APIError: Error, Sendable {
    case invalidURL
    // 인증이 필요한 요청에 토큰이 없거나, 서버가 401을 반환한 경우
    case unauthorized
    // 서버가 {code, message} 봉투로 내려준 실패 응답
    case server(code: String, message: String)
    case transport(String)
    case decoding(String)
}
