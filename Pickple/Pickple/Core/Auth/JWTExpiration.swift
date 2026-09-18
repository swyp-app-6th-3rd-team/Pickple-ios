//
//  JWTExpiration.swift
//  Pickple
//
//  Created by 박윤수 on 9/18/26.
//
//  accessToken(JWT)의 exp 클레임만 읽어서 "언제 만료되는지" 안다 — 서버가 TTL을 바꿔도
//  코드 수정 없이 그대로 맞는다. 우리가 이미 발급받은 우리 토큰이라 서명 검증은 하지 않는다.

import Foundation

enum JWTExpiration {
    static func decode(_ jwt: String) -> Date? {
        let segments = jwt.split(separator: ".")
        guard segments.count == 3 else { return nil }

        var base64 = String(segments[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        while base64.count % 4 != 0 { base64 += "=" }

        guard let data = Data(base64Encoded: base64),
              let payload = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let exp = payload["exp"] as? TimeInterval else { return nil }

        return Date(timeIntervalSince1970: exp)
    }
}
