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

// LocalizedError를 안 붙이면 error.localizedDescription이 "error 4"처럼
// enum 케이스 번호만 보여주는 의미 없는 문자열이 된다. alert에 실제 원인이 보이도록 명시한다.
extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 요청 주소입니다."
        case .unauthorized:
            return "인증이 만료됐습니다. 다시 로그인해주세요."
        case .server(let code, let message):
            return "\(message) (\(code))"
        case .transport(let message):
            return "네트워크 오류: \(message)"
        case .decoding(let message):
            return "응답을 처리하지 못했습니다: \(message)"
        }
    }
}
