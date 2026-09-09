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
    // multipart/form-data 업로드(POST /images)에서만 쓴다. body와는 배타적 — 둘 다 있으면 multipartFiles가 우선한다.
    var multipartFiles: [MultipartFile]? = nil
    var requiresAuth: Bool = false
    // 인증 없이도 호출 가능하지만(게스트 허용), 로그인 상태면 토큰을 실어서 서버가 개인화된
    // 데이터(예: 내 투표 여부)를 내려주게 한다. requiresAuth와 달리 토큰이 없어도 실패하지 않는다.
    var attachesAuthIfAvailable: Bool = false
}

// multipart/form-data 파트 하나(이미지 파일 하나).
struct MultipartFile: Sendable {
    let fieldName: String
    let filename: String
    let mimeType: String
    let data: Data
}
