//
//  KakaoLoginCoordinator.swift
//  Pickple
//
//  Created by 박윤수 on 9/6/26.
//
import Foundation
import KakaoSDKAuth
import KakaoSDKUser

class KakaoLoginCoordinator {
    private var rawNonce = ""
    
    struct KakaoLoginResult {
        let identityToken: String?
        let rawNonce: String
    }

    // 카카오톡 앱이 설치돼 있으면 앱 전환 로그인, 없으면 웹(계정) 로그인으로 자동 분기한다.
    func login() async throws -> KakaoLoginResult {
        rawNonce = randomNonceString()
        
        return try await withCheckedThrowingContinuation { continuation in
            let completion: (OAuthToken?, Error?) -> Void = { oauthToken, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let oauthToken else {
                    continuation.resume(throwing: APIError.decoding("Kakao 로그인 응답 파싱 실패"))
                    return
                }
                 continuation.resume(returning: KakaoLoginResult(
                    identityToken: oauthToken.idToken,
                    rawNonce: self.rawNonce
                ))
            }

            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk(nonce: rawNonce, completion: completion)
            } else {
                UserApi.shared.loginWithKakaoAccount(nonce: rawNonce, completion: completion)
            }
        }
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            var random: UInt8 = 0
            let status = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            guard status == errSecSuccess else {
                preconditionFailure("nonce 생성 실패")
            }
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
        return result
    }
}
