//
//  APIEnvelope.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import Foundation

// 모든 응답을 감싸는 공통 봉투: {"code": "OK", "message": "...", "returnObject": <T>}
// (API_SPEC.md 참고)
struct APIEnvelope<T: Decodable>: Decodable {
    let code: String
    let message: String
    let returnObject: T
}

// 응답 실패 시 본문에서 code/message만 읽어내기 위한 최소 봉투. returnObject 타입을 몰라도 디코딩된다.
struct APIEnvelopeMeta: Decodable {
    let code: String
    let message: String
}
