//
//  AppleLoginCoordinator.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//
import Foundation
import UIKit
import Security
import CryptoKit
import AuthenticationServices

class AppleLoginCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private var continuation: CheckedContinuation<AppleLoginResult, Error>?
    private var rawNonce = ""
    
    struct AppleLoginResult {
        let identityToken: String
        let authorizationCode: String
        let rawNonce: String
        let fullName: PersonNameComponents?
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let tokenData = credential.identityToken,
              let identityToken = String(data: tokenData, encoding: .utf8),
              let codeData = credential.authorizationCode,
              let authorizationCode = String(data: codeData, encoding: .utf8) else {
            continuation?.resume(throwing: APIError.decoding("Apple credential 파싱 실패"))
            return
        }
        continuation?.resume(returning: AppleLoginResult(
            identityToken: identityToken,
            authorizationCode: authorizationCode,
            rawNonce: rawNonce,
            fullName: credential.fullName
        ))
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
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
    
    func sha256(_ input: String) -> String {
        let hashed = SHA256.hash(data: Data(input.utf8))
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    func login() async throws -> AppleLoginResult {
            rawNonce = randomNonceString()

            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(rawNonce)

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self

            return try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
                controller.performRequests()
            }
        }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            UIApplication.shared.connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                .first ?? ASPresentationAnchor()
        }
}
