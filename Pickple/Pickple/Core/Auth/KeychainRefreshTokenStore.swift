//
//  KeychainRefreshTokenStore.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//

import Foundation
import Security

protocol RefreshTokenStoring: Sendable {
    func save(_ token: String) throws
    func load() -> String?
    func clear()
}

enum KeychainError: Error {
    case unhandled(OSStatus)
}

struct KeychainRefreshTokenStore: RefreshTokenStoring {
    private let service = "com.pickple.app.refreshToken"
    private let account = "refreshToken"

    private var baseQuery: [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
    }

    func save(_ token: String) throws {
        SecItemDelete(baseQuery as CFDictionary)
        var attributes = baseQuery
        attributes[kSecValueData as String] = Data(token.utf8)
        let status = SecItemAdd(attributes as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.unhandled(status) }
    }

    func load() -> String? {
        var query = baseQuery
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func clear() {
        SecItemDelete(baseQuery as CFDictionary)
    }
}
