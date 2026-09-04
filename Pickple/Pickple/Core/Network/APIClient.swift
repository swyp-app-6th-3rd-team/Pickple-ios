//
//  APIClient.swift
//  Pickple
//
//  Created by 박윤수 on 9/4/26.
//
//  각 도메인 Repository가 공통으로 쓰는 통신 도구.
//  요청 조립·인증 헤더 부착·{code,message,returnObject} 봉투 해석을 여기서만 처리한다.

import Foundation

protocol APIClientProtocol: Sendable {
    // returnObject가 있는 응답 (일반적인 조회/생성 등)
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
    // returnObject를 쓰지 않는 응답 (로그아웃, 삭제 등)
    func requestVoid(_ endpoint: APIEndpoint) async throws
}

// 모든 저장 프로퍼티가 let이고 URLSession·JSONDecoder·AccessTokenProviding(actor) 모두 동시성에 안전해 @unchecked Sendable로 선언한다.
final class APIClient: APIClientProtocol, @unchecked Sendable {
    private let baseURL: URL
    private let session: URLSession
    private let tokenProvider: AccessTokenProviding
    private let decoder: JSONDecoder

    init(
        baseURL: URL,
        session: URLSession = .shared,
        tokenProvider: AccessTokenProviding
    ) {
        self.baseURL = baseURL
        self.session = session
        self.tokenProvider = tokenProvider

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        let (data, _) = try await send(endpoint)
        do {
            return try decoder.decode(APIEnvelope<T>.self, from: data).returnObject
        } catch {
            throw APIError.decoding(String(describing: error))
        }
    }

    func requestVoid(_ endpoint: APIEndpoint) async throws {
        _ = try await send(endpoint)
    }

    // 요청을 만들어 보내고, 성공(2xx)이면 응답 데이터를 그대로 돌려준다. 실패면 서버가 준 code/message를 담아 던진다.
    private func send(_ endpoint: APIEndpoint) async throws -> (Data, HTTPURLResponse) {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }
        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }
        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        if endpoint.body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        if endpoint.requiresAuth {
            guard let token = await tokenProvider.accessToken() else {
                throw APIError.unauthorized
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.transport(String(describing: error))
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.transport("HTTPURLResponse가 아님")
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 401 {
                throw APIError.unauthorized
            }
            if let meta = try? decoder.decode(APIEnvelopeMeta.self, from: data) {
                throw APIError.server(code: meta.code, message: meta.message)
            }
            throw APIError.server(code: "HTTP_\(httpResponse.statusCode)", message: "요청이 실패했습니다")
        }

        return (data, httpResponse)
    }
}
