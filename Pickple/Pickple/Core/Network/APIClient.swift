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
        decoder.dateDecodingStrategy = .custom(Self.decodeFlexibleDate)
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
        if let files = endpoint.multipartFiles, !files.isEmpty {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = Self.multipartBody(files: files, boundary: boundary)
        } else {
            request.httpBody = endpoint.body
            if endpoint.body != nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        if endpoint.requiresAuth {
            guard let token = await tokenProvider.accessToken() else {
                throw APIError.unauthorized
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else if endpoint.attachesAuthIfAvailable, let token = await tokenProvider.accessToken() {
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

    // 서버 응답의 날짜 형식이 밀리초 유무·타임존 유무로 섞여 있어서(예: 스프링 부트가 흔히
    // 쓰는 타임존 없는 LocalDateTime 직렬화 "yyyy-MM-ddTHH:mm:ss"), 여러 형식을 순서대로
    // 시도한다. 타임존이 없는 형식은 UTC가 아니라 KST(Asia/Seoul)로 간주한다 — 한국 서비스라
    // 서버 로컬 시간이 KST일 가능성이 높고, UTC로 잘못 간주하면 표시 시각이 9시간 밀린다.
    // JSONDecoder.dateDecodingStrategy(.custom)가 기대하는 클로저 타입은 격리가 없는 동기
    // 함수라, -default-isolation=MainActor 기본값과 안 맞아 격리를 명시적으로 꺼야 한다.
    // 아래 포매터들은 설정 후 값이 안 바뀌는 불변 객체라 여러 컨텍스트에서 읽기만 해도 안전하다.
    nonisolated(unsafe) private static let iso8601WithFractional: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    nonisolated(unsafe) private static let iso8601Plain: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    nonisolated(unsafe) private static let noTimezoneWithFractional: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        return formatter
    }()

    nonisolated(unsafe) private static let noTimezonePlain: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()

    // 이 함수 자체도 nonisolated여야 위 .custom(Self.decodeFlexibleDate) 대입이 성립한다 —
    // 격리 없는 함수 4개를 읽기만 해서 안전하다.
    nonisolated private static func decodeFlexibleDate(from decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)

        if let date = iso8601WithFractional.date(from: dateString) { return date }
        if let date = iso8601Plain.date(from: dateString) { return date }
        if let date = noTimezoneWithFractional.date(from: dateString) { return date }
        if let date = noTimezonePlain.date(from: dateString) { return date }
        // 소수점 초 자릿수가 위 어느 것과도 안 맞으면, 앞 19자("yyyy-MM-ddTHH:mm:ss")만
        // 잘라서 마지막으로 시도한다.
        if dateString.count > 19, let date = noTimezonePlain.date(from: String(dateString.prefix(19))) {
            return date
        }

        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Expected date string to be ISO8601-formatted."
        )
    }

    private static func multipartBody(files: [MultipartFile], boundary: String) -> Data {
        var body = Data()
        for file in files {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(file.fieldName)\"; filename=\"\(file.filename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(file.mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(file.data)
            body.append("\r\n".data(using: .utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}
